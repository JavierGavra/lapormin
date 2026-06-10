import 'package:flutter/material.dart';
import 'package:lapormin/core/error/exceptions.dart';
import 'package:lapormin/core/services/push_notification/push_notification_service.dart';
import 'package:lapormin/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AuthLocalDataSource {
  Future<bool> saveUserData(UserModel user);
  Future<bool> clearUserData();
  Future<String> getDeviceToken();
  Future<String> getUserId();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  final PushNotificationService pushNotificationService;

  AuthLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.pushNotificationService,
  });

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

  @override
  Future<bool> clearUserData() async {
    try {
      await sharedPreferences.clear();
      return true;
    } catch (e) {
      debugPrint("$e");
      rethrow;
    }
  }

  @override
  Future<String> getDeviceToken() async {
    String? deviceToken = await pushNotificationService.messaging.getToken();

    if (deviceToken != null) {
      debugPrint('token = $deviceToken');
      return deviceToken;
    } else {
      throw const CacheException('Gagal membuat device token');
    }
  }

  @override
  Future<String> getUserId() async {
    final userId = sharedPreferences.getString('user_id');
    if (userId != null) {
      return userId;
    } else {
      throw const CacheException('User ID not found');
    }
  }
}
