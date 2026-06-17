import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/core/error/failures.dart';
import 'package:lapormin/core/use_case/usecase.dart';
import 'package:lapormin/features/profile/domain/repositories/profile_repository.dart';

class UploadPhotoProfile implements UseCase<String, UploadPhotoProfileParams> {
  final ProfileRepository repository;

  UploadPhotoProfile(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadPhotoProfileParams params) {
    return repository.uploadPhotoProfile(
      imageFile: params.imageFile,
      extension: params.extension,
    );
  }
}

class UploadPhotoProfileParams extends Equatable {
  final File imageFile;
  final String extension;

  const UploadPhotoProfileParams({
    required this.imageFile,
    required this.extension,
  });

  @override
  List<Object?> get props => [imageFile, extension];
}
