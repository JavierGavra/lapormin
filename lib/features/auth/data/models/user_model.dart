import 'package:lapormin/core/constants/user_role_enum.dart';
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.username,
    required super.phoneNumber,
    super.photoProfile,
    required super.role,
    required super.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'],
      username: data['username'],
      phoneNumber: data['no_telp'],
      photoProfile: data['photo_profile'],
      role: switch (data['role']) {
        'admin' => UserRole.admin,
        'informant' => UserRole.informant,
        'field_officer' => UserRole.fieldOfficer,
        _ => UserRole.informant,
      },
      createdAt: DateTime.parse(data['created_at']),
    );
  }
}
