import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

import 'package:lapormin/core/error/failures.dart';
import 'package:lapormin/core/use_case/usecase.dart';
import '../repositories/location_repository.dart';

class GetAddressFromCoordinate
    implements UseCase<String, GetAddressFromCoordinateParams> {
  final LocationRepository repository;

  const GetAddressFromCoordinate(this.repository);

  @override
  Future<Either<Failure, String>> call(GetAddressFromCoordinateParams params) {
    return repository.getAddressFromCoordinate(params.position);
  }
}

class GetAddressFromCoordinateParams extends Equatable {
  final LatLng position;

  const GetAddressFromCoordinateParams({required this.position});

  @override
  List<Object?> get props => [position];
}
