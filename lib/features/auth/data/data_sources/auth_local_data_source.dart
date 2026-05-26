import 'package:flutter/material.dart';
import 'package:lapormin/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AuthLocalDataSource {
  Future<bool> saveUserData(UserModel user);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> saveUserData(UserModel user) async {
    try {
      await sharedPreferences.setString('user_id', user.id);
      await sharedPreferences.setString('username', user.username);
      await sharedPreferences.setString('phone_number', user.phoneNumber);
      await sharedPreferences.setString(
        'created_at',
        user.createdAt.toIso8601String(),
      );
      await sharedPreferences.setString('role', user.role.dbValue);

      if (user.photoProfile != null) {
        await sharedPreferences.setString('photo_profile', user.photoProfile!);
      }

      return true;
    } catch (e) {
      debugPrint("$e");
      rethrow;
    }
  }
}
