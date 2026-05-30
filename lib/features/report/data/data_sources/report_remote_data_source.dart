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
      var query = supabase.from('report').select(_reportSummaryColumn);

      query = _applyFilter(query, filter);

      final response = await query
          .order('created_at', ascending: false)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw const TimeoutException(),
          );
      return response.map((e) => ReportSummaryModel.fromMap(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ReportSummaryModel>> fetchFieldOfficerReports(
    ReportFilterParams filter,
  ) async {
    try {
      final userId = supabase.auth.currentUser!.id;

      debugPrint("🔍 ID YANG LAGI LOGIN: $userId");

      var query = supabase
          .from('report')
          .select('$_reportSummaryColumn, field_check!inner(user_id)')
          .eq('field_check.user_id', userId);

      query = _applyFilter(query, filter);

      final response = await query
          .order('created_at', ascending: false)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw const TimeoutException(),
          );

      debugPrint("🔍 HASIL TARIK DATA: $response");

      return response.map((e) => ReportSummaryModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint("🔍 ERROR DARI SUPABASE: $e");
      rethrow;
    }
  }

  @override
  Future<List<ReportSummaryModel>> fetchPublicReports(
    ReportFilterParams filter,
  ) async {
    try {
      // 1. Tambahkan relasi evidences ke dalam select
      var query = supabase
          .from('report')
          .select('$_reportSummaryColumn, evidences:report_evidence(media)')
          .neq('status', 'pending')
          .neq('status', 'rejected')
          .limit(1, referencedTable: 'report_evidence');

      final response = await query
          .order('created_at', ascending: false)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw const TimeoutException(),
          );

      return response.map((e) {
        final Map<String, dynamic> rawData = Map<String, dynamic>.from(e);

        if (rawData['evidences'] != null &&
            (rawData['evidences'] as List).isNotEmpty) {
          final mediaPath = rawData['evidences'][0]['media'] as String;

          final publicUrl = supabase.storage
              .from('reports')
              .getPublicUrl(mediaPath);

          rawData['evidences'] = [publicUrl];
        } else {
          rawData['evidences'] = <String>[];
        }

        return ReportSummaryModel.fromMap(rawData);
      }).toList();
    } catch (e) {
      debugPrint("Error fetching public reports: $e");
      rethrow;
    }
  }

  @override
  Future<List<ReportSummaryModel>> fetchUserReports() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final response = await supabase
          .from('report')
          .select(_reportSummaryColumn)
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw const TimeoutException(),
          );
      return response.map((e) => ReportSummaryModel.fromMap(e)).toList();
    } catch (e) {
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

      return ReportAggregateModel.fromMap(response);
    } catch (e) {
      debugPrint("Error fetching report: $e");
      rethrow;
    }
  }
}
