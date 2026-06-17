import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/constants/report_status_enum.dart';
import '../../../../core/constants/user_role_enum.dart';
import '../../../../core/database/local_data_persistance.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/network/network_info.dart';
import '../../domain/entities/report.dart';
import '../../domain/entities/report_aggregate.dart';
import '../../domain/entities/report_summary.dart';
import '../../domain/params/report_filter_params.dart';
import '../../domain/repositories/report_repository.dart';
import '../../domain/use_cases/submit_field_check.dart';
import '../../domain/use_cases/submit_final_report.dart';
import '../../domain/use_cases/submit_report.dart';
import '../data_sources/report_remote_data_source.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource remoteDataSource;
  final LocalDataPersistance localDataPersistance;
  final NetworkInfo networkInfo;

  ReportRepositoryImpl({
    required this.localDataPersistance,
    required this.remoteDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, bool>> submitReport(SubmitReportParams params) async {
    try {
      final reportId = await remoteDataSource.insertReport(params);
      await remoteDataSource.insertReportEvidences(
        reportId,
        params.evidences,
        EvidenceType.report,
      );
      return Right(true);
    } on TimeoutException {
      return Left(NetworkFailure("Koneksi internet lambat. Coba lagi."));
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
    try {
      final data = await remoteDataSource.fetchFieldOfficerReports(filter);
      return Right(data);
    } on TimeoutException {
      return Left(NetworkFailure("Koneksi internet lambat. Coba lagi."));
    } catch (e) {
      return Left(ServerFailure());
    }
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

  @override
  Future<Either<Failure, ReportAggregate>> getReportAggregate(String id) async {
    try {
      final data = await remoteDataSource.fetchReportAggregate(id);
      return Right(data);
    } on TimeoutException {
      return Left(NetworkFailure("Koneksi internet lambat. Coba lagi."));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> assignFieldOfficer({
    required String reportId,
    required String fieldOfficerId,
  }) async {
    try {
      await remoteDataSource.assignFieldOfficer(reportId, fieldOfficerId);
      await remoteDataSource.updateReportStatus(
        reportId,
        ReportStatus.fieldCheck,
      );
      return Right(true);
    } on TimeoutException {
      return Left(NetworkFailure("Koneksi internet lambat. Coba lagi."));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Report>> updateReportStatus({
    required String id,
    required ReportStatus status,
  }) async {
    try {
      final data = await remoteDataSource.updateReportStatus(id, status);
      return Right(data);
    } on TimeoutException {
      return Left(NetworkFailure("Koneksi internet lambat. Coba lagi."));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> provideAction({
    required String reportId,
    required DateTime? dueAction,
  }) async {
    try {
      if (dueAction != null) {
        await remoteDataSource.provideAction(reportId, dueAction);
      }

      await remoteDataSource.updateReportStatus(reportId, ReportStatus.action);

      return Right(true);
    } on TimeoutException {
      return Left(NetworkFailure("Koneksi internet lambat. Coba lagi."));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> submitFieldCheck(
    SubmitFieldCheckParams params,
  ) async {
    try {
      await remoteDataSource.updateFieldCheck(params);
      await remoteDataSource.insertReportEvidences(
        params.fieldCheckId,
        params.evidences,
        EvidenceType.fieldCheck,
      );
      return Right(true);
    } on TimeoutException {
      return Left(NetworkFailure("Koneksi internet lambat. Coba lagi."));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> submitFinalReport(
    SubmitFinalReportParams params,
  ) async {
    try {
      final id = await remoteDataSource.insertFinalReport(params);
      await remoteDataSource.insertReportEvidences(
        id,
        params.evidences,
        EvidenceType.finalReport,
      );
      return Right(true);
    } on TimeoutException {
      return Left(NetworkFailure("Koneksi internet lambat. Coba lagi."));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>> getUserReportAmount() async {
    try {
      final role = UserRole.fromString(localDataPersistance.getRole ?? "");

      if (await networkInfo.isConnected) {
        final amount = await switch (role) {
          UserRole.admin => remoteDataSource.getAdminReportAmount(),
          UserRole.fieldOfficer =>
            remoteDataSource.getFieldOfficerReportAmount(),
          UserRole.informant => remoteDataSource.getInformantReportAmount(),
        };

        await localDataPersistance.setReportAmount(amount);
      }

      return Right(localDataPersistance.getReportAmount ?? 0);
    } on TimeoutException {
      return Left(NetworkFailure("Koneksi internet lambat. Coba lagi."));
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
