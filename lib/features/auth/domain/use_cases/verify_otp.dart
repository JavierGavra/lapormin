import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/core/error/failures.dart';
import 'package:lapormin/core/usecase/usecase.dart';
import 'package:lapormin/core/utils/phone_number/phone_number_format.dart';

import '../repositories/auth_repository.dart';

class VerifyOtp implements UseCase<bool, VerifyOtpParams> {
  final AuthRepository repository;

  const VerifyOtp(this.repository);

  @override
  Future<Either<Failure, bool>> call(params) async {
    return repository.verifyOtp(
      PhoneNumberFormat.international('+62', params.phone),
      params.otp,
    );
  }
}

class VerifyOtpParams extends Equatable {
  final String phone;
  final String otp;

  const VerifyOtpParams({required this.phone, required this.otp});

  @override
  List<Object?> get props => [phone, otp];
}
