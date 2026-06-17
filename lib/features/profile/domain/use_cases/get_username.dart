import 'package:dartz/dartz.dart';
import 'package:lapormin/core/error/failures.dart';
import 'package:lapormin/core/use_case/usecase.dart';
import 'package:lapormin/features/profile/domain/repositories/profile_repository.dart';

class GetUsername implements UseCase<String, NoParams> {
  final ProfileRepository repository;

  const GetUsername(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) {
    return repository.getUsername();
  }
}
