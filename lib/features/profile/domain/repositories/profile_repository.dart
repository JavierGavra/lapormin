import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/profile.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, Profile>> getProfile();
  Future<Either<Failure, String>> getUsername();
  Future<Either<Failure, void>> changePassword(
    String oldPassword,
    String newPassword,
  );
  Future<Either<Failure, String>> uploadPhotoProfile({
    required File imageFile,
    required String extension,
  });
  Future<Either<Failure, String>> changeUsername(String newUsername);
}
