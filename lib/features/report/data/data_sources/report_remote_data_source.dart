import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:lapormin/features/report/data/models/report_statistics_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/report_status_enum.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/params/report_filter_params.dart';
import '../../domain/use_cases/submit_field_check.dart';
import '../../domain/use_cases/submit_final_report.dart';
import '../../domain/use_cases/submit_report.dart';
import '../models/field_officer_statistics_model.dart'
    show FieldOfficerStatisticsModel;
import '../models/report_aggregate_model.dart';
import '../models/report_model.dart';
import '../models/report_summary_model.dart';

enum EvidenceType {
  report(
    folder: 'report_evidences',
    table: 'report_evidence',
    idField: 'report_id',
  ),
  fieldCheck(
    folder: 'field_check_evidences',
    table: 'field_check_evidence',
    idField: 'field_check_id',
  ),
  finalReport(
    folder: 'final_report_evidences',
    table: 'final_report_evidence',
    idField: 'final_report_id',
  );

  final String folder;
  final String table;
  final String idField;

  const EvidenceType({
    required this.folder,
    required this.table,
    required this.idField,
  });
}

abstract interface class ReportRemoteDataSource {
  Future<ReportStatisticsModel> fetchAdminReportStatistics();
  Future<String> insertReport(SubmitReportParams params);
  Future<FieldOfficerStatisticsModel> fetchFieldOfficerReportStatistics();
  Future<bool> insertReportEvidences(
    String referenceId,
    List<String> evidences,
    EvidenceType type,
  );
  Future<List<ReportSummaryModel>> fetchUserReports();
  Future<List<ReportSummaryModel>> fetchPublicReports(
    ReportFilterParams filter,
  );
  Future<List<ReportSummaryModel>> fetchAdminReports(ReportFilterParams filter);
  Future<List<ReportSummaryModel>> fetchFieldOfficerReports(
    ReportFilterParams filter,
  );
  Future<ReportModel> fetchReport(String id);
  Future<ReportAggregateModel> fetchReportAggregate(String id);
  Future<bool> deleteReport(String id);
  Future<ReportModel> updateReportStatus(String id, ReportStatus status);
  Future<bool> assignFieldOfficer(String reportId, String fieldOfficerId);
  Future<bool> provideAction(String id, DateTime? dueAction);
  Future<bool> updateFieldCheck(SubmitFieldCheckParams params);
  Future<String> insertFinalReport(SubmitFinalReportParams params);
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  final SupabaseClient supabase;

  const ReportRemoteDataSourceImpl({required this.supabase});

  final String _reportSummaryColumn =
      'id, title, address, category, status, created_at, due_action';

  PostgrestFilterBuilder<PostgrestList> _applyFilter(
    PostgrestFilterBuilder<PostgrestList> query,
    ReportFilterParams filter,
  ) {
    var filteredQuery = query;

    if (filter.categories.isNotEmpty) {
      final categoryDbValues = filter.categories.map((e) => e.dbValue).toList();
      filteredQuery = filteredQuery.inFilter('category', categoryDbValues);
    }

    if (filter.statuses.isNotEmpty) {
      final statusDbValues = filter.statuses.map((e) => e.dbValue).toList();
      filteredQuery = filteredQuery.inFilter('status', statusDbValues);
    }

    if (filter.keyword != null && filter.keyword!.isNotEmpty) {
      filteredQuery = filteredQuery.ilike('title', '%${filter.keyword}%');
    }

    return filteredQuery;
  }

  String? _resolveEvidenceUrl(dynamic evidences) {
    final media = (evidences as List?)?.firstOrNull?['media'] as String?;
    if (media == null) return null;
    return supabase.storage.from('reports').getPublicUrl(media);
  }

  List<String> _resolveEvidenceUrls(dynamic evidences) {
    final list = evidences as List?;
    if (list == null || list.isEmpty) return [];

    return list.map((evidence) {
      final mediaPath = evidence['media'] as String;
      return supabase.storage.from('reports').getPublicUrl(mediaPath);
    }).toList();
  }

  @override
  Future<String> insertReport(SubmitReportParams params) async {
    try {
      final response = await supabase
          .from('report')
          .insert({
            'title': params.title,
            'user_id': supabase.auth.currentUser!.id,
            'description': params.description,
            'address': params.address,
            'latitude': params.latitude,
            'longitude': params.longitude,
            'category': params.category.dbValue,
            'status': ReportStatus.pending.dbValue,
          })
          .select('id')
          .single()
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw const TimeoutException(),
          );

      return response['id'];
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw ServerException("$e");
    }
  }

  @override
  Future<bool> insertReportEvidences(
    String referenceId,
    List<String> evidences,
    EvidenceType type,
  ) async {
    try {
      const String bucketName = 'reports';

      final List<Map<String, dynamic>> evidenceDataToInsert = await Future.wait(
        evidences.map((localPath) async {
          final file = File(localPath);

          final extension = localPath.split('.').last;
          final fileName = '${localPath.hashCode}.$extension';
          final storageFilePath = '${type.folder}/$referenceId/$fileName';

          await supabase.storage.from(bucketName).upload(storageFilePath, file);

          return {type.idField: referenceId, 'media': storageFilePath};
        }),
      );

      if (evidenceDataToInsert.isNotEmpty) {
        await supabase.from(type.table).insert(evidenceDataToInsert);
      }

      return true;
    } catch (e) {
      debugPrint("Error inserting report evidences: $e");
      rethrow;
    }
  }

  @override
  Future<List<ReportSummaryModel>> fetchAdminReports(
    ReportFilterParams filter,
  ) async {
    try {
      var query = supabase
          .from('report')
          .select('$_reportSummaryColumn, evidence:report_evidence(media)');

      final response = await _applyFilter(query, filter)
          .limit(1, referencedTable: 'report_evidence')
          .order('created_at', ascending: false)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw const TimeoutException(),
          );

      return response.map((e) {
        return ReportSummaryModel.fromMap({
          ...e,
          'evidence': _resolveEvidenceUrl(e['evidence']),
        });
      }).toList();
    } catch (e) {
      debugPrint("$e");
      rethrow;
    }
  }

  @override
  Future<List<ReportSummaryModel>> fetchFieldOfficerReports(
    ReportFilterParams filter,
  ) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      var query = supabase
          .from('report')
          .select('''
            $_reportSummaryColumn,
            evidence:report_evidence(media),
            field_check!inner(user_id)
          ''')
          .eq('field_check.user_id', userId);

      final response = await _applyFilter(query, filter)
          .order('created_at', ascending: false)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw const TimeoutException(),
          );

      return response.map((e) {
        return ReportSummaryModel.fromMap({
          ...e,
          'evidence': _resolveEvidenceUrl(e['evidence']),
        });
      }).toList();
    } catch (e) {
      debugPrint("$e");
      rethrow;
    }
  }

  @override
  Future<List<ReportSummaryModel>> fetchPublicReports(
    ReportFilterParams filter,
  ) async {
    try {
      var query = supabase
          .from('report')
          .select('$_reportSummaryColumn, evidence:report_evidence(media)')
          .neq('status', 'pending')
          .neq('status', 'rejected');

      final response = await _applyFilter(query, filter)
          .limit(1, referencedTable: 'report_evidence')
          .order('created_at', ascending: false)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw const TimeoutException(),
          );

      return response.map((e) {
        return ReportSummaryModel.fromMap({
          ...e,
          'evidence': _resolveEvidenceUrl(e['evidence']),
        });
      }).toList();
    } catch (e) {
      debugPrint("$e");
      rethrow;
    }
  }

  @override
  Future<List<ReportSummaryModel>> fetchUserReports() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      var response = await supabase
          .from('report')
          .select('$_reportSummaryColumn, evidence:report_evidence(media)')
          .eq('user_id', userId)
          .limit(1, referencedTable: 'report_evidence')
          .order('created_at', ascending: false)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw const TimeoutException(),
          );

      return response.map((e) {
        return ReportSummaryModel.fromMap({
          ...e,
          'evidence': _resolveEvidenceUrl(e['evidence']),
        });
      }).toList();
    } catch (e) {
      debugPrint("$e");
      rethrow;
    }
  }

  @override
  Future<bool> deleteReport(String id) async {
    // TODO: implement deleteReport
    throw UnimplementedError();
  }

  @override
  Future<ReportModel> fetchReport(String id) async {
    try {
      final response = await supabase
          .from('report')
          .select('''
            *,
            evidences: report_evidence (
              media
            )
          ''')
          .eq('id', id)
          .single()
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw const TimeoutException(),
          );

      final rawData = response;

      rawData['evidences'] = _resolveEvidenceUrls(rawData['evidences']);

      return ReportModel.fromMap(rawData);
    } catch (e) {
      debugPrint("Error fetching report: $e");
      rethrow;
    }
  }

  @override
  Future<ReportAggregateModel> fetchReportAggregate(String id) async {
    try {
      final response = await supabase
          .from('report')
          .select('''
            *,
            evidences: report_evidence (media),
            report_status_logs: report_status_log (
              id, user_id, status, created_at
            ),
            field_check (
              *,
              evidences: field_check_evidence (media),
              ...users(
                field_officer_name: username,
                field_officer_phone: no_telp
              )
            ),
            final_report (
              *,
              evidences: final_report_evidence (media)
            )
          ''')
          .eq('id', id)
          .single()
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw const TimeoutException(),
          );

      final rawData = Map<String, dynamic>.from(response);

      // Resolve report evidences
      rawData['evidences'] = _resolveEvidenceUrls(rawData['evidences']);

      // Resolve field_check evidences
      if (rawData['field_check'] != null) {
        final fieldCheck = Map<String, dynamic>.from(rawData['field_check']);
        fieldCheck['evidences'] = _resolveEvidenceUrls(fieldCheck['evidences']);
        rawData['field_check'] = fieldCheck;
      }

      // Resolve final_report evidences
      if (rawData['final_report'] != null) {
        final finalReport = Map<String, dynamic>.from(rawData['final_report']);
        finalReport['evidences'] = _resolveEvidenceUrls(
          finalReport['evidences'],
        );
        rawData['final_report'] = finalReport;
      }

      return ReportAggregateModel.fromMap(rawData);
    } catch (e) {
      debugPrint("Error fetching report aggregate: $e");
      rethrow;
    }
  }

  @override
  Future<ReportModel> updateReportStatus(String id, ReportStatus status) async {
    try {
      final response = await supabase
          .from('report')
          .update({'status': status.dbValue})
          .eq('id', id)
          .select()
          .single();

      return ReportModel.fromMap(response);
    } catch (e) {
      debugPrint('$e');
      rethrow;
    }
  }

  @override
  Future<bool> assignFieldOfficer(
    String reportId,
    String fieldOfficerId,
  ) async {
    try {
      await supabase.from('field_check').insert({
        'report_id': reportId,
        'user_id': fieldOfficerId,
      });

      return true;
    } catch (e) {
      debugPrint('$e');
      rethrow;
    }
  }

  @override
  Future<bool> provideAction(String id, DateTime? dueAction) async {
    try {
      await supabase
          .from('report')
          .update({
            'due_action': dueAction != null
                ? DateFormat('yyyy-MM-dd').format(dueAction)
                : null,
          })
          .eq('id', id)
          .select()
          .single();

      return true;
    } catch (e) {
      debugPrint('$e');
      rethrow;
    }
  }

  @override
  Future<bool> updateFieldCheck(SubmitFieldCheckParams params) async {
    try {
      await supabase
          .from('field_check')
          .update({'description': params.description})
          .eq('id', params.fieldCheckId)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw const TimeoutException(),
          );

      return true;
    } catch (e) {
      debugPrint('$e');
      rethrow;
    }
  }

  @override
  Future<String> insertFinalReport(SubmitFinalReportParams params) async {
    try {
      final response = await supabase
          .from('final_report')
          .insert({
            'report_id': params.reportId,
            'description': params.description,
          })
          .select('id')
          .single()
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw const TimeoutException(),
          );

      return response['id'];
    } catch (e) {
      debugPrint('$e');
      rethrow;
    }
  }

  @override
  Future<ReportStatisticsModel> fetchAdminReportStatistics() async {
    try {
      final results = await Future.wait([
        supabase
            .from('report')
            .count(CountOption.exact)
            .eq('status', 'pending'),
        supabase.from('report').count(CountOption.exact).inFilter('status', [
          'verified',
          'field_check',
          'action',
        ]),
        supabase.from('report').count(CountOption.exact).eq('status', 'done'),
        supabase.from('report').count(CountOption.exact),

        supabase
            .from('report')
            .count(CountOption.exact)
            .eq('category', 'infrastructure'),
        supabase
            .from('report')
            .count(CountOption.exact)
            .eq('category', 'disaster'),
        supabase
            .from('report')
            .count(CountOption.exact)
            .eq('category', 'crime'),
        supabase
            .from('report')
            .count(CountOption.exact)
            .eq('category', 'public_service'),
      ]);

      return ReportStatisticsModel(
        pending: results[0],
        processing: results[1],
        done: results[2],
        total: results[3],
        infrastructure: results[4],
        disaster: results[5],
        crime: results[6],
        publicService: results[7],
      );
    } catch (e) {
      debugPrint("Error fetching report statistics: $e");
      throw ServerException("$e");
    }
  }

  @override
  Future<FieldOfficerStatisticsModel>
  fetchFieldOfficerReportStatistics() async {
    try {
      final userId = supabase.auth.currentUser!.id;

      final results = await Future.wait([
        supabase
            .from('field_check')
            .select('id, report!inner(status)')
            .eq('user_id', userId)
            .eq('report.status', 'field_check'),

        supabase
            .from('field_check')
            .select('id, report!inner(status)')
            .eq('user_id', userId)
            .eq('report.status', 'action'),
      ]);

      final inspeksiCount = results[0].length;
      final tindakanCount = results[1].length;

      return FieldOfficerStatisticsModel(
        inspeksi: inspeksiCount,
        tindakan: tindakanCount,
        penugasan: inspeksiCount + tindakanCount,
      );
    } catch (e) {
      debugPrint("Error fetching field officer statistics: $e");
      throw ServerException("$e");
    }
  }
}
