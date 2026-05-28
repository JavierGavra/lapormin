import '../../domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.reportAmount,
    required super.username,
    required super.phoneNumber,
    super.photoProfile,
    required super.createdAt,
  });
}
