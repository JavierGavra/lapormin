import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_case/usecase.dart';
import '../repositories/auth_repository.dart';

class Logout implements UseCase<bool, NoParams> {
  final AuthRepository repository;

  const Logout(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.logout();
  }
}
