import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:lapormin/core/utils/network/network_info.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../data_sources/profile_local_data_source.dart';
import '../data_sources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource local;
  final ProfileRemoteDataSource remote;
  final NetworkInfo networkInfo;

  const ProfileRepositoryImpl({
    required this.local,
    required this.remote,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Profile>> getProfile() async {
    try {
      Profile profile = await local.getProfile();
      return Right(profile);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getUsername() async {
    try {
      return Right(local.getUsername());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> uploadPhotoProfile({
    required File imageFile,
    required String extension,
  }) async {
    try {
      if (!await networkInfo.isConnected) return const Left(NetworkFailure());

      final result = await remote.upsertPhotoProfile(imageFile, extension);

      await local.setPhotoProfile(result);

      return Right(true);
    } on NetworkException {
      return Left(NetworkFailure());
    } on TimeoutException {
      return Left(NetworkFailure("Koneksi internet lambat. Coba lagi."));
    } catch (e) {
      return Left(ServerFailure('Gagal mengubah foto profil'));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      if (!await networkInfo.isConnected) return const Left(NetworkFailure());

      await remote.changePassword(oldPassword, newPassword);
      return const Right(null);
    } on NetworkException {
      return Left(NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> changeUsername(String newUsername) async {
    try {
      if (!await networkInfo.isConnected) return const Left(NetworkFailure());

      final result = await remote.updateUsername(newUsername);
      await local.setUsername(result);
      return Right(result);
    } on NetworkException {
      return Left(NetworkFailure());
    } on TimeoutException {
      return Left(NetworkFailure("Koneksi internet lambat. Coba lagi."));
    } catch (e) {
      return Left(ServerFailure('Gagal mengubah username'));
    }
  }
}
