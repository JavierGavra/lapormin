import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';

import 'package:lapormin/core/error/failures.dart';
import '../entities/location.dart';

abstract class LocationRepository {
  Future<Either<Failure, Location>> getCurrentLocation();
  Future<Either<Failure, String>> getAddressFromCoordinate(LatLng position);
}
