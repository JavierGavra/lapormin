import 'package:flutter/material.dart';

import '../../../../core/constants/user_role_enum.dart';
import '../../../../core/database/local_data_persistance.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/push_notification/push_notification_service.dart';
import '../models/user_model.dart';

abstract interface class AuthLocalDataSource {
  Future<bool> saveUserData(UserModel user);
  Future<bool> clearUserData();
  Future<String> getDeviceToken();
  String getUserId();
  UserModel getUserData();
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

  @override
  UserModel getUserData() {
    try {
      return UserModel(
        id: localDataPersistance.getUserId!,
        username: localDataPersistance.getUsername!,
        phoneNumber: localDataPersistance.getPhoneNumber!,
        createdAt: DateTime.parse(localDataPersistance.getCreatedAt!),
        role: UserRole.fromString(localDataPersistance.getRole!),
        photoProfile: localDataPersistance.getPhotoProfile,
      );
    } catch (e) {
      debugPrint("$e");
      rethrow;
    }
  }
}
