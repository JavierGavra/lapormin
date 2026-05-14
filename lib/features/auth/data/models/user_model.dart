import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.username,
    required super.phoneNumber,
    super.photoProfile,
    required super.role,
  });

  factory UserModel.fromAuthResponse(AuthResponse response) {
    final user = response.user;
    if (user == null) {
      throw Exception('User data is missing in the authentication response');
    }

    return UserModel(
      id: user.id,
      username: user.userMetadata?['username'] ?? '',
      phoneNumber: user.phone ?? '',
      photoProfile: user.userMetadata?['photoProfile'],
      role: user.userMetadata?['role'] ?? 'user',
    );
  }
}
