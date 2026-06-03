import 'package:dartz/dartz.dart';
import 'package:lapormin/core/error/exceptions.dart';
import 'package:lapormin/core/error/failures.dart';
import 'package:lapormin/features/map/domain/repositories/map_repository.dart';
import '../../domain/entities/map_report.dart';
import '../data_sources/map_remote_data_source.dart';
import '../models/map_report_model.dart';

class MapRepositoryImpl implements MapRepository {
  final MapRemoteDataSource remoteDataSource;

  MapRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MapReport>>> getNearbyActiveReports({
    required double latitude,
    required double longitude,
    required double radiusKm,
  }) async {
    try {
      final response = await remoteDataSource.getNearbyActiveReports(
        latitude,
        longitude,
        radiusKm,
      );

      final reports = response.map((e) => MapReportModel.fromMap(e)).toList();
      return Right(reports);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('Terjadi kesalahan sistem saat memproses peta.'),
      );
    }
  }
}
