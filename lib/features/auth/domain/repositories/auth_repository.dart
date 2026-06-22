import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, bool>> isPhoneExist(String phoneNumber);
  Future<Either<Failure, void>> sendOtp(
    String username,
    String phoneNumber,
    String password,
  );
  Future<Either<Failure, bool>> verifyOtp(String phoneNumber, String otp);
  Future<Either<Failure, User>> login(String phoneNumber, String password);
  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, User>> getCurrentUser();
}
