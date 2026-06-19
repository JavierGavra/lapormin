import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/error/exceptions.dart';
import '../../models/field_officer_statistics_model.dart';
import '../../models/report_statistics_model.dart';

abstract interface class ReportStatisticRemoteDataSource {
  Future<ReportStatisticsModel> fetchAdminReportStatistics();
  Future<FieldOfficerStatisticsModel> fetchFieldOfficerReportStatistics();
  Future<int> getAdminReportAmount();
  Future<int> getFieldOfficerReportAmount();
  Future<int> getInformantReportAmount();
}

class ReportStatisticRemoteDataSourceImpl
    implements ReportStatisticRemoteDataSource {
  final SupabaseClient supabase;

  const ReportStatisticRemoteDataSourceImpl({required this.supabase});

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
    } on SocketException {
      throw const NetworkException("Tidak ada koneksi internet");
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
    } on SocketException {
      throw const NetworkException("Tidak ada koneksi internet");
    } catch (e) {
      debugPrint("Error fetching field officer statistics: $e");
      throw ServerException("$e");
    }
  }

  @override
  Future<int> getAdminReportAmount() async {
    try {
      final response = await supabase.from('report').count(CountOption.exact);

      return response;
    } on SocketException {
      throw const NetworkException("Tidak ada koneksi internet");
    } catch (e) {
      debugPrint("$e");
      rethrow;
    }
  }

  @override
  Future<int> getFieldOfficerReportAmount() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final response = await supabase
          .from('field_check')
          .count(CountOption.exact)
          .eq('user_id', userId);

      return response;
    } on SocketException {
      throw const NetworkException("Tidak ada koneksi internet");
    } catch (e) {
      debugPrint("$e");
      rethrow;
    }
  }

  @override
  Future<int> getInformantReportAmount() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final response = await supabase
          .from('report')
          .count(CountOption.exact)
          .eq('user_id', userId);

      return response;
    } on SocketException {
      throw const NetworkException("Tidak ada koneksi internet");
    } catch (e) {
      debugPrint("$e");
      rethrow;
    }
  }
}
