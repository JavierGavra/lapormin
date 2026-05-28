import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart';

import '../../../../core/error/exceptions.dart';
import '../models/profile_model.dart';

abstract interface class ProfileLocalDataSource {
  Future<ProfileModel> getProfile();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences prefs;

  const ProfileLocalDataSourceImpl({required this.prefs});

  @override
  Future<ProfileModel> getProfile() {
    try {
      final username = prefs.getString("username") ?? "User";
      final phoneNumber = prefs.getString("phone_number") ?? "----";
      final photoProfile = prefs.getString("photo_profile");
      final createdAt = prefs.getString("created_at") ?? "-";
      return Future.value(
        ProfileModel(
          username: username,
          phoneNumber: phoneNumber,
          photoProfile: photoProfile,
          createdAt: DateTime.tryParse(createdAt) ?? DateTime(1945, 8, 17),
          reportAmount: 0, // Replace with actual value if available
        ),
      );
    } catch (e) {
      debugPrint("$e");
      throw CacheException("Failed to load profile from local storage: $e");
    }
  }
}
