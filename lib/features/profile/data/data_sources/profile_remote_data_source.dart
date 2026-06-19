import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';

abstract class ProfileRemoteDataSource {
  Future<String> upsertPhotoProfile(File imageFile, String extension);
  Future<void> changePassword(String oldPassword, String newPassword);
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

      final existingFiles = await supabase.storage
          .from('avatars')
          .list(path: userId);

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
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      throw Exception('Gagal mengunggah foto profil: $e');
    }
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      await supabase.auth.updateUser(UserAttributes(password: newPassword));
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      rethrow;
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
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      debugPrint('$e');
      rethrow;
    }
  }

  @override
  Future<String> getPhotoProfile(String path) async {
    try {
      return supabase.storage.from('avatars').getPublicUrl(path);
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      debugPrint('$e');
      rethrow;
    }
  }
}
