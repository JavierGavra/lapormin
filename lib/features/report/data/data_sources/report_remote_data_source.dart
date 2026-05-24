import 'package:lapormin/features/report/data/models/report_summary_model.dart';
import 'package:lapormin/features/report/domain/params/report_filter_params.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:lapormin/core/constants/report_status_enum.dart';
import 'package:lapormin/core/error/exceptions.dart';
import '../../domain/use_cases/submit_report.dart';

abstract interface class ReportRemoteDataSource {
  Future<bool> insertReport(SubmitReportParams params);
  Future<bool> insertReportEvidences(List<String> evidences);
  Future<List<ReportSummaryModel>> fetchUserReports();
  Future<List<ReportSummaryModel>> fetchPublicReports(
    ReportFilterParams filter,
  );
  Future<List<ReportSummaryModel>> fetchAdminReports(ReportFilterParams filter);
  Future<List<ReportSummaryModel>> fetchFieldOfficerReports(
    ReportFilterParams filter,
  );
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
  Future<bool> insertReport(SubmitReportParams params) async {
    try {
      await supabase.from('report').insert({
        'title': params.title,
        'user_id': supabase.auth.currentUser!.id,
        'description': params.description,
        'address': params.address,
        'latitude': params.latitude,
        'longitude': params.longitude,
        'category': params.category.dbValue,
        'status': ReportStatus.pending.dbValue,
      });

      return true;
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw ServerException("$e");
    }
  }

  @override
  Future<bool> insertReportEvidences(List<String> evidences) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
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
    // TODO: Implement field officer report
    throw UnimplementedError();
  }

  @override
  Future<List<ReportSummaryModel>> fetchPublicReports(
    ReportFilterParams filter,
  ) async {
    try {
      var query = supabase
          .from('report')
          .select(_reportSummaryColumn)
          .neq('status', 'pending')
          .neq('status', 'rejected');

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
}
