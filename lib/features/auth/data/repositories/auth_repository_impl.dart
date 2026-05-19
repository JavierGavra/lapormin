import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:lapormin/core/error/exceptions.dart';
import 'package:lapormin/core/error/failures.dart';
import 'package:lapormin/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lapormin/features/auth/domain/entities/user.dart';
import 'package:lapormin/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

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
      final response = await remoteDataSource.postLogin(phoneNumber, password);
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
  Future<Either<Failure, bool>> logout() {
    throw UnimplementedError();
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
}
