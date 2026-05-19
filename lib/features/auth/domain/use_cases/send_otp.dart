import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/core/error/failures.dart';
import 'package:lapormin/core/usecase/usecase.dart';

import '../repositories/auth_repository.dart';

class SendOtp implements UseCase<void, SendOtpParams> {
  final AuthRepository repository;

  const SendOtp(this.repository);

  @override
  Future<Either<Failure, void>> call(params) async {
    return repository.sendOtp(
      params.username,
      "+62${params.phone}",
      params.password,
    );
  }
}

class SendOtpParams extends Equatable {
  final String username;
  final String phone;
  final String password;

  const SendOtpParams({
    required this.username,
    required this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [username, phone, password];
}
