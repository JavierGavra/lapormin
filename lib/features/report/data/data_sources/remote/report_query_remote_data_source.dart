import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../domain/params/report_filter_params.dart';
import '../../models/report_aggregate_model.dart';
import '../../models/report_model.dart';
import '../../models/report_summary_model.dart';

abstract interface class ReportQueryRemoteDataSource {
  Future<ReportModel> fetchReport(String id);
  Future<ReportAggregateModel> fetchReportAggregate(String id);
  Future<List<ReportSummaryModel>> fetchPublicReports(
    ReportFilterParams filter,
  );
  Future<List<ReportSummaryModel>> fetchAdminReports(ReportFilterParams filter);
  Future<List<ReportSummaryModel>> fetchFieldOfficerReports(
    ReportFilterParams filter,
  );
  Future<List<ReportSummaryModel>> fetchUserReports();
}

class ReportQueryRemoteDataSourceImpl implements ReportQueryRemoteDataSource {
  final SupabaseClient supabase;

  const ReportQueryRemoteDataSourceImpl({required this.supabase});

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
    } on SocketException {
      throw const NetworkException("Tidak ada koneksi internet");
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
    } on SocketException {
      throw const NetworkException("Tidak ada koneksi internet");
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
    } on SocketException {
      throw const NetworkException("Tidak ada koneksi internet");
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
    } on SocketException {
      throw const NetworkException("Tidak ada koneksi internet");
    } catch (e) {
      debugPrint("$e");
      rethrow;
    }
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
    } on SocketException {
      throw const NetworkException("Tidak ada koneksi internet");
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
    } on SocketException {
      throw const NetworkException("Tidak ada koneksi internet");
    } catch (e) {
      debugPrint("Error fetching report aggregate: $e");
      rethrow;
    }
  }
}
