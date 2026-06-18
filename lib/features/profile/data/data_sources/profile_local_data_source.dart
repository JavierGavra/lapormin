import 'package:flutter/widgets.dart';

import '../../../../core/database/local_data_persistance.dart';
import '../../../../core/error/exceptions.dart';
import '../models/profile_model.dart';

abstract interface class ProfileLocalDataSource {
  Future<ProfileModel> getProfile();
  Future<void> setPhotoProfile(String photoProfile);
  Future<void> setUsername(String username);
  String getUsername();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final LocalDataPersistance localDataPersistance;

  const ProfileLocalDataSourceImpl({required this.localDataPersistance});

  @override
  Future<ProfileModel> getProfile() {
    try {
      final username = localDataPersistance.getUsername ?? "User";
      final phoneNumber = localDataPersistance.getPhoneNumber ?? "----";
      final photoProfile = localDataPersistance.getPhotoProfile;
      final createdAt = localDataPersistance.getCreatedAt ?? "-";
      final reportAmount = localDataPersistance.getReportAmount ?? 0;
      return Future.value(
        ProfileModel(
          username: username,
          phoneNumber: phoneNumber,
          photoProfile: photoProfile,
          createdAt: DateTime.tryParse(createdAt) ?? DateTime(1945, 8, 17),
          reportAmount: reportAmount,
        ),
      );
    } catch (e) {
      debugPrint("$e");
      throw CacheException("Failed to load profile from local storage: $e");
    }
  }

  @override
  String getUsername() {
    try {
      return localDataPersistance.getUsername ?? "User";
    } catch (e) {
      debugPrint("$e");
      rethrow;
    }
  }

  @override
  Future<void> setPhotoProfile(String photoProfile) {
    try {
      return localDataPersistance.setPhotoProfile(photoProfile);
    } catch (e) {
      debugPrint("$e");
      rethrow;
    }
  }

  @override
  Future<void> setUsername(String username) {
    try {
      return localDataPersistance.setUsername(username);
    } catch (e) {
      debugPrint("$e");
      rethrow;
    }
  }
}
