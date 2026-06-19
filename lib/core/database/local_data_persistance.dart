import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataPersistance {
  final SharedPreferences _prefs;

  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _phoneNumberKey = 'phone_number';
  static const String _createdAtKey = 'created_at';
  static const String _roleKey = 'role';
  static const String _reportAmountKey = 'report_amount';

  const LocalDataPersistance(this._prefs);

  Future<void> clear() async {
    await _prefs.clear();

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/photo_profile.png');
      if (await file.exists()) {
        await file.delete();
        await FileImage(file).evict();
      }
    } catch (e) {
      debugPrint("Gagal menghapus foto profil luring: $e");
    }
  }

  // =========== Getters ===========
  String? get getUserId => _prefs.getString(_userIdKey);
  String? get getUsername => _prefs.getString(_usernameKey);
  String? get getPhoneNumber => _prefs.getString(_phoneNumberKey);
  String? get getCreatedAt => _prefs.getString(_createdAtKey);
  String? get getRole => _prefs.getString(_roleKey);
  int? get getReportAmount => _prefs.getInt(_reportAmountKey);

  Future<File?> get getPhotoProfile async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/photo_profile.png';
    final file = File(filePath);

    if (await file.exists()) return file;

    return null;
  }

  // =========== Setters ===========
  Future<void> setUserId(String userId) async {
    await _prefs.setString(_userIdKey, userId);
  }

  Future<void> setUsername(String username) async {
    await _prefs.setString(_usernameKey, username);
  }

  Future<void> setPhoneNumber(String phoneNumber) async {
    await _prefs.setString(_phoneNumberKey, phoneNumber);
  }

  Future<void> setCreatedAt(DateTime createdAt) async {
    await _prefs.setString(_createdAtKey, createdAt.toIso8601String());
  }

  Future<void> setRole(String role) async {
    await _prefs.setString(_roleKey, role);
  }

  Future<void> setReportAmount(int reportAmount) async {
    await _prefs.setInt(_reportAmountKey, reportAmount);
  }

  Future<void> setPhotoProfile(String photoSource) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/photo_profile.png';
      final file = File(filePath);

      if (photoSource.startsWith('http://') ||
          photoSource.startsWith('https://')) {
        final response = await http.get(Uri.parse(photoSource));

        if (response.statusCode == 200) {
          await file.writeAsBytes(response.bodyBytes);
        } else {
          throw Exception('Gagal mengunduh gambar dari peladen');
        }
      } else {
        final sourceFile = File(photoSource);
        if (await sourceFile.exists()) {
          await sourceFile.copy(filePath);
        }
      }

      await FileImage(file).evict();
    } catch (e) {
      debugPrint("Error menyimpan foto profil: $e");
    }
  }
}
