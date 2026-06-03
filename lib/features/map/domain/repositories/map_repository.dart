import 'package:dartz/dartz.dart';
import 'package:lapormin/core/error/failures.dart';
import '../entities/map_report.dart';

abstract class MapRepository {
  // Sekarang kita minta data koordinat dan radius radius KM
  Future<Either<Failure, List<MapReport>>> getNearbyActiveReports({
    required double latitude,
    required double longitude,
    required double radiusKm,
  });
}
