import 'package:flutter/material.dart';
import 'package:lapormin/core/database/local_data_persistance.dart';
import 'package:lapormin/core/error/exceptions.dart';
import 'package:lapormin/core/services/push_notification/push_notification_service.dart';
import 'package:lapormin/features/auth/data/models/user_model.dart';

abstract interface class AuthLocalDataSource {
  Future<bool> saveUserData(UserModel user);
  Future<bool> clearUserData();
  Future<String> getDeviceToken();
  String getUserId();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final LocalDataPersistance localDataPersistance;
  final PushNotificationService pushNotificationService;

  AuthLocalDataSourceImpl({
    required this.localDataPersistance,
    required this.pushNotificationService,
  });

  @override
  Future<bool> saveUserData(UserModel user) async {
    try {
      await localDataPersistance.setUserId(user.id);
      await localDataPersistance.setUsername(user.username);
      await localDataPersistance.setPhoneNumber(user.phoneNumber);
      await localDataPersistance.setCreatedAt(user.createdAt);
      await localDataPersistance.setRole(user.role.dbValue);

      if (user.photoProfile != null) {
        await localDataPersistance.setPhotoProfile(user.photoProfile!);
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
      await localDataPersistance.clear();
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
  String getUserId() {
    final userId = localDataPersistance.getUserId;
    if (userId != null) {
      return userId;
    } else {
      throw const CacheException('User ID not found');
    }
  }
}
