import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_local_data_source.dart';
import '../data_sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
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
      final deviceToken = await localDataSource.getDeviceToken();
      final response = await remoteDataSource.postLogin(phoneNumber, password);

      await remoteDataSource.postDeviceToken(response.id, deviceToken);
      await localDataSource.saveUserData(response);
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
      final userId = localDataSource.getUserId();
      await remoteDataSource.removeDeviceToken(userId);
      bool result = await remoteDataSource.postLogout();

      if (result) result = await localDataSource.clearUserData();

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
      await remoteDataSource.sendOtp(username, phoneNumber, password);
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
      final result = await remoteDataSource.verifyOtp(phoneNumber, otp);
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
      final profile = localDataSource.getUserData();
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
