import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:lapormin/core/constants/report_status_enum.dart';
import 'package:lapormin/core/error/exceptions.dart';
import '../../domain/use_cases/submit_report.dart';

abstract interface class ReportRemoteDataSource {
  Future<bool> insertReport(SubmitReportParams params);
  Future<bool> insertReportEvidences(List<String> evidences);
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  final SupabaseClient supabase;

  const ReportRemoteDataSourceImpl({required this.supabase});

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
        'category': params.category.value,
        'status': ReportStatus.pending.dbValue,
      });

      return true;
    } catch (e) {
      print("Error inserting report: $e");
      if (e is NetworkException) rethrow;
      throw ServerException("$e");
    }
  }

  @override
  Future<bool> insertReportEvidences(List<String> evidences) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
