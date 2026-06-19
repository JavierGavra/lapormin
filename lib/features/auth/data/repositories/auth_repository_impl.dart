import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:lapormin/core/utils/network/network_info.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_local_data_source.dart';
import '../data_sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource local;
  final AuthRemoteDataSource remote;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.local,
    required this.remote,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, bool>> isPhoneExist(String phoneNumber) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> login(
    String phoneNumber,
    String password,
  ) async {
    try {
      if (!await networkInfo.isConnected) return const Left(NetworkFailure());

      final deviceToken = await local.getDeviceToken();
      final response = await remote.postLogin(phoneNumber, password);
      final photoProfile = await remote.fetchPhotoProfile();

      await remote.postDeviceToken(response.id, deviceToken);

      if (photoProfile != null) {
        await local.savePhotoProfile(photoProfile);
      }

      await local.saveUserData(response);
      return Right(response);
    } catch (e) {
      if (kDebugMode) print(e);
      if (e is InvalidCredentialsException) {
        return Left(ValidationFailure("Nomor telepon atau password salah."));
      } else if (e is ServerException) {
        return Left(ServerFailure(e.message!));
      } else if (e is NetworkException) {
        return Left(NetworkFailure());
      } else {
        return const Left(ServerFailure('Gagal login. Coba lagi nanti.'));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      if (!await networkInfo.isConnected) return const Left(NetworkFailure());

      final userId = local.getUserId();
      await remote.removeDeviceToken(userId);
      bool result = await remote.postLogout();

      if (result) result = await local.clearUserData();

      return Right(result);
    } catch (e) {
      if (kDebugMode) print(e);
      if (e is InvalidCredentialsException) {
        return Left(ValidationFailure("Gagal logout."));
      } else if (e is ServerException) {
        return Left(ServerFailure(e.message!));
      } else if (e is NetworkException) {
        return Left(NetworkFailure());
      } else {
        return const Left(ServerFailure('Gagal logout. Coba lagi nanti.'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> sendOtp(
    String username,
    String phoneNumber,
    String password,
  ) async {
    try {
      if (!await networkInfo.isConnected) return const Left(NetworkFailure());

      await remote.sendOtp(username, phoneNumber, password);
      return Right(null);
    } catch (e) {
      if (kDebugMode) print(e);
      if (e is NetworkException) {
        return Left(NetworkFailure());
      } else if (e is InvalidCredentialsException) {
        return Left(ValidationFailure('Data tidak valid.'));
      } else {
        return Left(ServerFailure('Gagal mengirim OTP. Coba lagi nanti.'));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> verifyOtp(
    String phoneNumber,
    String otp,
  ) async {
    try {
      if (!await networkInfo.isConnected) return const Left(NetworkFailure());
      final result = await remote.verifyOtp(phoneNumber, otp);
      return Right(result);
    } catch (e) {
      if (kDebugMode) print("$e");
      if (e is NetworkException) {
        return Left(NetworkFailure());
      } else if (e is ServerException) {
        return Left(ServerFailure());
      } else {
        return Left(ServerFailure("Kode OTP salah atau kadaluarsa"));
      }
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final profile = await local.getUserData();
      return Right(
        User(
          id: profile.id,
          username: profile.username,
          phoneNumber: profile.phoneNumber,
          createdAt: profile.createdAt,
          role: profile.role,
          photoProfile: profile.photoProfile,
        ),
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
