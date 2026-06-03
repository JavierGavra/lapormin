import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/report_status_enum.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/params/report_filter_params.dart';
import '../../domain/use_cases/submit_report.dart';
import '../models/report_aggregate_model.dart';
import '../models/report_model.dart';
import '../models/report_summary_model.dart';

abstract interface class ReportRemoteDataSource {
  Future<String> insertReport(SubmitReportParams params);
  Future<bool> insertReportEvidences(String reportId, List<String> evidences);
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

    if (filter.category != null) {
      filteredQuery = filteredQuery.eq('category', filter.category!.dbValue);
    }

    if (filter.status != null) {
      filteredQuery = filteredQuery.eq('status', filter.status!.dbValue);
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
    String reportId,
    List<String> evidences,
  ) async {
    try {
      final List<Map<String, dynamic>> evidenceDataToInsert = [];

      const String bucketName = 'reports';
      const String folderName = 'report_evidences';

      await Future.wait(
        evidences.map((localPath) async {
          final file = File(localPath);

          final extension = localPath.split('.').last;
          final fileName = '${localPath.hashCode}.$extension';
          final storageFilePath = '$folderName/$reportId/$fileName';

          await supabase.storage.from(bucketName).upload(storageFilePath, file);

          evidenceDataToInsert.add({
            'report_id': reportId,
            'media': storageFilePath,
          });
        }),
      );

      if (evidenceDataToInsert.isNotEmpty) {
        await supabase.from('report_evidence').insert(evidenceDataToInsert);
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

      if (rawData['evidences'] != null) {
        final List<dynamic> rawEvidences = rawData['evidences'];

        final List<String> imageUrls = rawEvidences.map((evidence) {
          final mediaPath = evidence['media'] as String;
          return supabase.storage.from('reports').getPublicUrl(mediaPath);
        }).toList();

        rawData['evidences'] = imageUrls;
      }

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
              evidences: report_evidence (
                media
              ),
              report_status_logs: report_status_log (
                id, user_id, status, created_at
              ),
              field_check (
                *,
                ...users(
                  field_officer_name: username,
                  field_officer_phone: no_telp
                )
              ),
              final_report (*)
            ''')
          .eq('id', id)
          .single()
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw const TimeoutException(),
          );

      final rawData = response;

      if (rawData['evidences'] != null) {
        final List<dynamic> rawEvidences = rawData['evidences'];

        final List<String> imageUrls = rawEvidences.map((evidence) {
          final mediaPath = evidence['media'] as String;
          return supabase.storage.from('reports').getPublicUrl(mediaPath);
        }).toList();

        rawData['evidences'] = imageUrls;
      }

      return ReportAggregateModel.fromMap(rawData);
    } catch (e) {
      debugPrint("Error fetching report: $e");
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
          .update({'due_action': dueAction})
          .eq('id', id)
          .select()
          .single();

      return true;
    } catch (e) {
      debugPrint('$e');
      rethrow;
    }
  }
}
