import 'package:dartz/dartz.dart';
import 'package:lapormin/core/error/failures.dart';
import 'package:lapormin/core/use_case/usecase.dart';
import 'package:lapormin/features/profile/domain/entities/profile.dart';
import 'package:lapormin/features/profile/domain/repositories/profile_repository.dart';

class GetProfile implements UseCase<Profile, NoParams> {
  final ProfileRepository repository;

  const GetProfile(this.repository);

  @override
  Future<Either<Failure, Profile>> call(NoParams params) {
    return repository.getProfile();
  }
}
