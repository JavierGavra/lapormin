import 'dart:async';

import 'package:dartz/dartz.dart';

import 'package:lapormin/core/error/failures.dart';
import 'package:lapormin/features/report/domain/entities/report.dart';
import 'package:lapormin/features/report/domain/entities/report_summary.dart';
import 'package:lapormin/features/report/domain/params/report_filter_params.dart';
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

  @override
  Future<Either<Failure, List<ReportSummary>>> getAdminReports(
    ReportFilterParams filter,
  ) async {
    try {
      final data = await remoteDataSource.fetchAdminReports(filter);
      return Right(data);
    } on TimeoutException {
      return Left(NetworkFailure("Koneksi internet lambat. Coba lagi."));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ReportSummary>>> getFieldOfficerReports(
    ReportFilterParams filter,
  ) async {
    // TODO: implement getFieldOfficerReports
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<ReportSummary>>> getPublicReports(
    ReportFilterParams filter,
  ) async {
    try {
      final data = await remoteDataSource.fetchPublicReports(filter);
      return Right(data);
    } on TimeoutException {
      return Left(NetworkFailure("Koneksi internet lambat. Coba lagi."));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ReportSummary>>> getUserReports() async {
    try {
      final data = await remoteDataSource.fetchUserReports();
      return Right(data);
    } on TimeoutException {
      return Left(NetworkFailure("Koneksi internet lambat. Coba lagi."));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteReport(String reportId) async {
    // TODO: implement deleteReport
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Report>> getReport(String id) async {
    try {
      final data = await remoteDataSource.fetchReport(id);
      return Right(data);
    } on TimeoutException {
      return Left(NetworkFailure("Koneksi internet lambat. Coba lagi."));
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
