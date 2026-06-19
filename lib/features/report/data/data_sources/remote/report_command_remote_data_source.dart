import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/constants/report_status_enum.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../domain/use_cases/submit_field_check.dart';
import '../../../domain/use_cases/submit_final_report.dart';
import '../../../domain/use_cases/submit_report.dart';
import '../../models/report_model.dart';

abstract interface class ReportCommandRemoteDataSource {
  Future<String> insertReport(SubmitReportParams params);
  Future<String> insertFinalReport(SubmitFinalReportParams params);
  Future<ReportModel> updateReportStatus(String id, ReportStatus status);
  Future<bool> updateFieldCheck(SubmitFieldCheckParams params);
  Future<bool> assignFieldOfficer(String reportId, String fieldOfficerId);
  Future<bool> provideAction(String id, DateTime? dueAction);
  Future<bool> deleteReport(String id);
}

class ReportCommandRemoteDataSourceImpl
    implements ReportCommandRemoteDataSource {
  final SupabaseClient supabase;

  const ReportCommandRemoteDataSourceImpl({required this.supabase});

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
    } on SocketException {
      throw const NetworkException("Tidak ada koneksi internet");
    } catch (e) {
      debugPrint('$e');
      rethrow;
    }
  }

  @override
  Future<bool> deleteReport(String id) async {
    try {
      await supabase
          .from('report')
          .delete()
          .eq('id', id)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw const TimeoutException(),
          );

      return true;
    } on SocketException {
      throw const NetworkException("Tidak ada koneksi internet");
    } catch (e) {
      debugPrint('$e');
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
    } on SocketException {
      throw const NetworkException("Tidak ada koneksi internet");
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
    } on SocketException {
      throw const NetworkException("Tidak ada koneksi internet");
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
    } on SocketException {
      throw const NetworkException("Tidak ada koneksi internet");
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
    } on SocketException {
      throw const NetworkException("Tidak ada koneksi internet");
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
    } on SocketException {
      throw const NetworkException("Tidak ada koneksi internet");
    } catch (e) {
      debugPrint('$e');
      rethrow;
    }
  }
}
