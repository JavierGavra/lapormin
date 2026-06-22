import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/core/error/failures.dart';
import 'package:lapormin/core/use_case/usecase.dart';
import 'package:lapormin/features/profile/domain/repositories/profile_repository.dart';

class ChangeUsername implements UseCase<String, ChangeUsernameParams> {
  final ProfileRepository repository;

  ChangeUsername(this.repository);

  @override
  Future<Either<Failure, String>> call(ChangeUsernameParams params) {
    return repository.changeUsername(params.newUsername);
  }
}

class ChangeUsernameParams extends Equatable {
  final String newUsername;

  const ChangeUsernameParams({required this.newUsername});

  @override
  List<Object> get props => [newUsername];
}
