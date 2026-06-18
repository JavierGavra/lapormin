import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:lapormin/core/constants/user_role_enum.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String phoneNumber;
  final File? photoProfile;
  final UserRole role;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.username,
    required this.phoneNumber,
    this.photoProfile,
    required this.role,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    username,
    phoneNumber,
    photoProfile,
    role,
    createdAt,
  ];
}
