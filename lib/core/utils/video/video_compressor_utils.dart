import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';

class VideoCompressorUtils {
  static Future<File?> compressVideo(File file) async {
    try {
      final MediaInfo? mediaInfo = await VideoCompress.compressVideo(
        file.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
        includeAudio: true,
      );

      if (mediaInfo != null && mediaInfo.file != null) {
        return mediaInfo.file;
      }
      return null;
    } catch (e) {
      debugPrint('❌ Gagal kompres video: $e');
      return file;
    }
  }

  static Future<void> clearCache() async {
    await VideoCompress.deleteAllCache();
  }

  static Future<File?> generateThumbnail(String videoPath) async {
    try {
      final Uint8List? bytes = await VideoCompress.getByteThumbnail(
        videoPath,
        quality: 75,
        position: -1, // -1 = ambil dari frame pertama
      );

      if (bytes == null) return null;

      final tempDir = await getTemporaryDirectory();
      final fileName = 'thumb_${videoPath.hashCode}.jpg';
      final thumbnailFile = File('${tempDir.path}/$fileName');

      await thumbnailFile.writeAsBytes(bytes);
      return thumbnailFile;
    } catch (e) {
      debugPrint('❌ Gagal generate thumbnail: $e');
      return null;
    }
  }
}
