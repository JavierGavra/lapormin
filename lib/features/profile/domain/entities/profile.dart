import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final int reportAmount;
  final String username;
  final String phoneNumber;
  final String? photoProfile;
  final DateTime createdAt;

  const Profile({
    required this.reportAmount,
    required this.username,
    required this.phoneNumber,
    required this.photoProfile,
    required this.createdAt,
  });

  Profile copyWith({
    int? reportAmount,
    String? username,
    String? phoneNumber,
    String? photoProfile,
    DateTime? createdAt,
  }) {
    return Profile(
      reportAmount: reportAmount ?? this.reportAmount,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoProfile: photoProfile ?? this.photoProfile,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    reportAmount,
    username,
    phoneNumber,
    photoProfile,
    createdAt,
  ];
}
