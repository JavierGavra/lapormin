import 'package:dartz/dartz.dart';
import 'package:lapormin/core/error/failures.dart';
import 'package:lapormin/features/auth/domain/entities/user.dart';
import 'package:lapormin/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either<Failure, User>> register(
    String username,
    String phoneNumber,
    String password,
  ) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> login(String phoneNumber, password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> isPhoneExist(String phoneNumber) {
    // TODO: implement isPhoneExist
    throw UnimplementedError();
  }
}
