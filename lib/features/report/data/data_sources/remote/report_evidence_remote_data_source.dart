import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:lapormin/core/utils/video/video_compressor_utils.dart';
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

  Future<String?> _uploadThumbnail({
    required String bucketName,
    required String localVideoPath,
    required String referenceId,
    required String folder,
  }) async {
    try {
      final thumbnailFile = await VideoCompressorUtils.generateThumbnail(
        localVideoPath,
      );

      if (thumbnailFile == null) return null;

      final thumbStoragePath =
          '$folder/$referenceId/thumb_${localVideoPath.hashCode}.jpg';

      await supabase.storage
          .from(bucketName)
          .upload(
            thumbStoragePath,
            thumbnailFile,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: true,
            ),
          );

      await thumbnailFile.delete();

      return thumbStoragePath;
    } catch (e) {
      debugPrint('❌ Gagal upload thumbnail: $e');
      return null;
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

          final extension = localPath.split('.').last.toLowerCase();
          final fileName = '${localPath.hashCode}.$extension';
          final storageFilePath = '${type.folder}/$referenceId/$fileName';

          // Tentukan MIME type berdasarkan ekstensi
          String contentType = 'application/octet-stream';
          if (['jpg', 'jpeg', 'png', 'webp'].contains(extension)) {
            contentType = 'image/$extension';
          } else if (['mp4', 'mov', 'avi'].contains(extension)) {
            contentType = 'video/$extension';
          }

          // Tambahkan fileOptions agar Supabase mengenali format video/gambar
          await supabase.storage
              .from(bucketName)
              .upload(
                storageFilePath,
                file,
                fileOptions: FileOptions(
                  contentType: contentType,
                  upsert: true,
                ),
              );

          final isVideo = ['mp4', 'mov', 'avi'].contains(extension);

          // ✅ Untuk video: generate dan upload thumbnail
          String? thumbnailPath;
          if (isVideo) {
            thumbnailPath = await _uploadThumbnail(
              bucketName: bucketName,
              localVideoPath: localPath,
              referenceId: referenceId,
              folder: type.folder,
            );
          }

          return {
            type.idField: referenceId,
            'media': storageFilePath,
            'thumbnail': ?thumbnailPath,
          };
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
