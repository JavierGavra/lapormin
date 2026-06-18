import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileRemoteDataSource {
  Future<String> upsertPhotoProfile(File imageFile, String extension);
  Future<String> updateUsername(String newUsername);
  Future<String> getPhotoProfile(String path);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient supabase;

  ProfileRemoteDataSourceImpl({required this.supabase});

  @override
  Future<String> upsertPhotoProfile(File imageFile, String extension) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final fileName = 'avatar_${imageFile.hashCode}.$extension';
      final filePath = '$userId/$fileName';

      final bytes = await imageFile.readAsBytes();

      // Ambil daftar semua file yang ada di dalam folder userId
      final existingFiles = await supabase.storage
          .from('avatars')
          .list(path: userId);

      // Jika ada file, hapus semuanya agar storage tetap bersih
      if (existingFiles.isNotEmpty) {
        final filesToDelete = existingFiles
            .map((f) => '$userId/${f.name}')
            .toList();
        await supabase.storage.from('avatars').remove(filesToDelete);
      }

      await supabase.storage
          .from('avatars')
          .uploadBinary(
            filePath,
            bytes,
            fileOptions: const FileOptions(upsert: true),
          );

      await supabase
          .from("users")
          .update({"photo_profile": filePath})
          .eq("id", userId);

      return supabase.storage.from('avatars').getPublicUrl(filePath);
    } catch (e) {
      throw Exception('Gagal mengunggah foto profil: $e');
    }
  }

  @override
  Future<String> updateUsername(String newUsername) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      await supabase
          .from("users")
          .update({"username": newUsername})
          .eq("id", userId);

      return newUsername;
    } catch (e) {
      debugPrint('$e');
      rethrow;
    }
  }

  @override
  Future<String> getPhotoProfile(String path) async {
    try {
      return supabase.storage.from('avatars').getPublicUrl(path);
    } catch (e) {
      debugPrint('$e');
      rethrow;
    }
  }
}
