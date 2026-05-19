import 'package:lapormin/core/constants/user_role_enum.dart';

class User {
  final String id;
  final String username;
  final String phoneNumber;
  final String? photoProfile;
  final UserRole role;

  User({
    required this.id,
    required this.username,
    required this.phoneNumber,
    this.photoProfile,
    required this.role,
  });
}
