import 'package:dartz/dartz.dart';

import 'package:lapormin/core/error/failures.dart';
import '../../domain/repositories/report_repository.dart';
import '../../domain/use_cases/submit_report.dart';
import '../data_sources/report_remote_data_source.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource remoteDataSource;

  ReportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, bool>> submitReport(SubmitReportParams params) async {
    try {
      await remoteDataSource.insertReport(params);
      await remoteDataSource.insertReportEvidences(params.evidences);
      return Right(true);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
