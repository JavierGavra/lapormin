import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/core/error/failures.dart';
import 'package:lapormin/core/use_case/usecase.dart';
import '../entities/map_report.dart';
import '../repositories/map_repository.dart';

class GetNearbyActiveReports
    implements UseCase<List<MapReport>, GetNearbyActiveReportsParams> {
  final MapRepository repository;

  const GetNearbyActiveReports(this.repository);

  @override
  Future<Either<Failure, List<MapReport>>> call(
    GetNearbyActiveReportsParams params,
  ) {
    return repository.getNearbyActiveReports(
      latitude: params.latitude,
      longitude: params.longitude,
      radiusKm: params.radiusKm,
    );
  }
}

class GetNearbyActiveReportsParams extends Equatable {
  final double latitude;
  final double longitude;
  final double radiusKm;

  const GetNearbyActiveReportsParams({
    required this.latitude,
    required this.longitude,
    this.radiusKm = 5.0, // Default pencarian 5 KM
  });

  @override
  List<Object?> get props => [latitude, longitude, radiusKm];
}
