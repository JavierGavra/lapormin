import 'package:dartz/dartz.dart';
import 'package:lapormin/core/error/failures.dart';

import '../entities/user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> login(String phoneNumber, String password);
  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, User>> register(
    String username,
    String phoneNumber,
    String password,
  );
}
