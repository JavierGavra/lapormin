import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/core/error/failures.dart';
import 'package:lapormin/core/use_case/usecase.dart';
import 'package:lapormin/core/utils/phone_number/phone_number_format.dart';
import 'package:lapormin/features/auth/domain/entities/user.dart';
import 'package:lapormin/features/auth/domain/repositories/auth_repository.dart';

class Login implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  const Login(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) {
    return repository.login(
      PhoneNumberFormat.international('+62', params.phoneNumber),
      params.password,
    );
  }
}

class LoginParams extends Equatable {
  final String phoneNumber;
  final String password;

  const LoginParams({required this.phoneNumber, required this.password});

  @override
  List<Object?> get props => [phoneNumber, password];
}
