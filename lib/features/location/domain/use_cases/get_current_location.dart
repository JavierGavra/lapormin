import 'package:dartz/dartz.dart';
import 'package:lapormin/core/error/failures.dart';
import 'package:lapormin/core/use_case/usecase.dart';

import '../entities/location.dart';
import '../repositories/location_repository.dart';

class GetCurrentLocation implements UseCase<Location, NoParams> {
  final LocationRepository repository;

  const GetCurrentLocation(this.repository);

  @override
  Future<Either<Failure, Location>> call(NoParams params) {
    return repository.getCurrentLocation();
  }
}
