import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/error/exceptions.dart';

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

abstract interface class ReportEvidenceRemoteDataSource {
  Future<bool> insertReportEvidences(
    String referenceId,
    List<String> evidences,
    EvidenceType type,
  );
}

class ReportEvidenceRemoteDataSourceImpl
    implements ReportEvidenceRemoteDataSource {
  final SupabaseClient supabase;

  ReportEvidenceRemoteDataSourceImpl({required this.supabase});

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
    } on SocketException {
      throw const NetworkException("Tidak ada koneksi internet");
    } catch (e) {
      debugPrint("Error inserting report evidences: $e");
      rethrow;
    }
  }
}
