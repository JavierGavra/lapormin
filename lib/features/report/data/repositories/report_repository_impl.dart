import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/constants/report_status_enum.dart';
import '../../../../core/constants/user_role_enum.dart';
import '../../../../core/database/local_data_persistance.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/network/network_info.dart';
import '../../domain/entities/field_officer_statistics.dart';
import '../../domain/entities/report.dart';
import '../../domain/entities/report_aggregate.dart';
import '../../domain/entities/report_statistics.dart';
import '../../domain/entities/report_summary.dart';
import '../../domain/params/report_filter_params.dart';
import '../../domain/repositories/report_repository.dart';
import '../../domain/use_cases/submit_field_check.dart';
import '../../domain/use_cases/submit_final_report.dart';
import '../../domain/use_cases/submit_report.dart';
import '../data_sources/remote/report_evidence_remote_data_source.dart';
import '../data_sources/remote/report_remote_data_source_facade.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSourceFacade remote;
  final LocalDataPersistance localPersistance;
  final NetworkInfo networkInfo;

  ReportRepositoryImpl({
    required this.localPersistance,
    required this.remote,
    required this.networkInfo,
  });

  Future<Either<Failure, T>> _execute<T>(Future<T> Function() call) async {
    try {
      if (!await networkInfo.isConnected) return Left(NetworkFailure());
      final result = await call();
      return Right(result);
    } on NetworkException {
      return Left(NetworkFailure());
    } on TimeoutException {
      return Left(NetworkFailure("Koneksi internet lambat. Coba lagi."));
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ReportAggregate>> getReportAggregate(String id) =>
      _execute(() => remote.query.fetchReportAggregate(id));

  @override
  Future<Either<Failure, List<ReportSummary>>> getAdminReports(
    ReportFilterParams filter,
  ) => _execute(() => remote.query.fetchAdminReports(filter));

  @override
  Future<Either<Failure, List<ReportSummary>>> getPublicReports(
    ReportFilterParams filter,
  ) => _execute(() => remote.query.fetchPublicReports(filter));

  @override
  Future<Either<Failure, List<ReportSummary>>> getFieldOfficerReports(
    ReportFilterParams filter,
  ) => _execute(() => remote.query.fetchFieldOfficerReports(filter));

  @override
  Future<Either<Failure, List<ReportSummary>>> getUserReports() =>
      _execute(() => remote.query.fetchUserReports());

  @override
  Future<Either<Failure, Report>> getReport(String id) =>
      _execute(() => remote.query.fetchReport(id));

  @override
  Future<Either<Failure, bool>> deleteReport(String reportId) =>
      _execute(() => remote.command.deleteReport(reportId));

  @override
  Future<Either<Failure, Report>> updateReportStatus({
    required String id,
    required ReportStatus status,
  }) => _execute(() => remote.command.updateReportStatus(id, status));

  @override
  Future<Either<Failure, ReportStatistics>> getAdminReportStatistics() =>
      _execute(() => remote.statistic.fetchAdminReportStatistics());

  @override
  Future<Either<Failure, FieldOfficerStatistics>>
  getFieldOfficerReportStatistics() =>
      _execute(() => remote.statistic.fetchFieldOfficerReportStatistics());

  @override
  Future<Either<Failure, bool>> submitReport(SubmitReportParams params) =>
      _execute(() async {
        final reportId = await remote.command.insertReport(params);
        await remote.evidence.insertReportEvidences(
          reportId,
          params.evidences,
          EvidenceType.report,
        );
        return true;
      });

  @override
  Future<Either<Failure, bool>> assignFieldOfficer({
    required String reportId,
    required String fieldOfficerId,
  }) => _execute(() async {
    await remote.command.assignFieldOfficer(reportId, fieldOfficerId);
    await remote.command.updateReportStatus(reportId, ReportStatus.fieldCheck);
    return true;
  });

  @override
  Future<Either<Failure, bool>> provideAction({
    required String reportId,
    required DateTime? dueAction,
  }) => _execute(() async {
    if (dueAction != null) {
      await remote.command.provideAction(reportId, dueAction);
    }
    await remote.command.updateReportStatus(reportId, ReportStatus.action);
    return true;
  });

  @override
  Future<Either<Failure, bool>> submitFieldCheck(
    SubmitFieldCheckParams params,
  ) => _execute(() async {
    await remote.command.updateFieldCheck(params);
    await remote.evidence.insertReportEvidences(
      params.fieldCheckId,
      params.evidences,
      EvidenceType.fieldCheck,
    );
    return true;
  });

  @override
  Future<Either<Failure, bool>> submitFinalReport(
    SubmitFinalReportParams params,
  ) => _execute(() async {
    final id = await remote.command.insertFinalReport(params);
    await remote.evidence.insertReportEvidences(
      id,
      params.evidences,
      EvidenceType.finalReport,
    );
    return true;
  });

  @override
  Future<Either<Failure, int>> getUserReportAmount() => _execute(() async {
    final role = UserRole.fromString(localPersistance.getRole ?? "");
    final amount = await switch (role) {
      UserRole.admin => remote.statistic.getAdminReportAmount(),
      UserRole.fieldOfficer => remote.statistic.getFieldOfficerReportAmount(),
      UserRole.informant => remote.statistic.getInformantReportAmount(),
    };
    await localPersistance.setReportAmount(amount);

    return localPersistance.getReportAmount ?? 0;
  });
}
