import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/usecase.dart';
import '../repositories/profile_repository.dart';

class ChangePasswordParams extends Equatable {
  final String oldPassword;
  final String newPassword;

  const ChangePasswordParams({
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [oldPassword, newPassword];
}

class ChangePassword implements UseCase<void, ChangePasswordParams> {
  final ProfileRepository repository;

  ChangePassword(this.repository);

  @override
  Future<Either<Failure, void>> call(ChangePasswordParams params) {
    return repository.changePassword(params.oldPassword, params.newPassword);
  }
}
