import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:lapormin/core/constants/constant.dart';

class InputValidator {
  static String? empty(String? value) {
    return value.toString().trim().isEmpty ? 'Bidang tidak boleh kosong' : null;
  }

  static String? phone(String? value) {
    final isValid = RegExp(r'^\d{10,15}$').hasMatch(value.toString());
    return !isValid ? 'Nomor telepon tidak valid' : null;
  }

  static String? password(String? value) {
    if (value.toString().length < 8) {
      return 'Kata sandi harus minimal 8 karakter';
    }
    return null;
  }

  static String? confirmPassword(String? value, String? password) {
    return value != password ? 'Kata sandi tidak cocok' : null;
  }

  static String? evidenceValidate({
    required String filePath,
    required int currentTotalBytes,
  }) {
    final ext = path.extension(filePath).replaceFirst('.', '').toLowerCase();

    if (!Constant.evidenceExtensions.contains(ext)) {
      return 'Format ($ext) tidak didukung. Gunakan PNG, JPG, JPEG, HEIC, MP4, atau MOV.';
    }

    final fileSize = File(filePath).lengthSync();
    if (currentTotalBytes + fileSize > Constant.evidencesMaxBytes) {
      final remaining =
          (Constant.evidencesMaxBytes - currentTotalBytes) / (1024 * 1024);
      return 'Melebihi 50 MB. Sisa: ${remaining.toStringAsFixed(1)} MB.';
    }

    return null;
  }
}
