import 'package:dartz/dartz.dart';
import 'package:lapormin/core/error/exceptions.dart';
import 'package:lapormin/core/error/failures.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/entities/location.dart';
import '../../domain/repositories/location_repository.dart';
import '../data_sources/location_local_data_source.dart';
import '../data_sources/location_remote_data_source.dart';
import '../models/location_model.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationLocalDataSource localDataSource;
  final LocationRemoteDataSource remoteDataSource;

  const LocationRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, Location>> getCurrentLocation() async {
    try {
      final position = await localDataSource.getCurrentPosition();
      final address = await remoteDataSource.getAddressFromCoordinate(position);
      return Right(LocationModel(position: position, address: address));
    } on LocationException catch (e) {
      return Left(LocationFailure(e.message));
    } catch (e) {
      return Left(
        LocationFailure("Terjadi kesalahan saat mendapatkan lokasi."),
      );
    }
  }

  @override
  Future<Either<Failure, String>> getAddressFromCoordinate(
    LatLng position,
  ) async {
    try {
      final address = await remoteDataSource.getAddressFromCoordinate(position);
      return Right(address);
    } on LocationException catch (e) {
      return Left(LocationFailure(e.message));
    } catch (e) {
      return Left(
        LocationFailure("Terjadi kesalahan saat mendapatkan alamat."),
      );
    }
  }
}
