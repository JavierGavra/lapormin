import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageCompressorUtils {
  static Future<File?> compressImage(File file) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath =
          '${dir.absolute.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.webp';

      final XFile? compressedXFile =
          await FlutterImageCompress.compressAndGetFile(
            file.absolute.path,
            targetPath,
            quality: 80,
            minWidth: 1280,
            minHeight: 1280,
            format: CompressFormat.webp,
          );

      if (compressedXFile == null) return null;

      return File(compressedXFile.path);
    } catch (e) {
      debugPrint('❌ Gagal kompres: $e');
      return file;
    }
  }
}
