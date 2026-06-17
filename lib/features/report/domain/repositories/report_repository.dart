import 'package:dartz/dartz.dart';

import '../../../../core/constants/report_status_enum.dart';
import '../../../../core/error/failures.dart';
import '../entities/field_officer_statistics.dart' show FieldOfficerStatistics;
import '../entities/report.dart';
import '../entities/report_aggregate.dart';
import '../entities/report_summary.dart';
import '../params/report_filter_params.dart';
import '../use_cases/submit_field_check.dart';
import '../use_cases/submit_final_report.dart';
import '../use_cases/submit_report.dart';
import '../entities/report_statistics.dart';

abstract interface class ReportRepository {
  Future<Either<Failure, bool>> submitReport(SubmitReportParams params);
  Future<Either<Failure, ReportStatistics>> getAdminReportStatistics();
  Future<Either<Failure, List<ReportSummary>>> getUserReports();
  Future<Either<Failure, FieldOfficerStatistics>>
  getFieldOfficerReportStatistics();
  Future<Either<Failure, List<ReportSummary>>> getPublicReports(
    ReportFilterParams filter,
  );
  Future<Either<Failure, List<ReportSummary>>> getAdminReports(
    ReportFilterParams filter,
  );
  Future<Either<Failure, List<ReportSummary>>> getFieldOfficerReports(
    ReportFilterParams filter,
  );
  Future<Either<Failure, Report>> getReport(String id);
  Future<Either<Failure, ReportAggregate>> getReportAggregate(String id);
  Future<Either<Failure, Report>> updateReportStatus({
    required String id,
    required ReportStatus status,
  });
  Future<Either<Failure, bool>> deleteReport(String id);
  Future<Either<Failure, bool>> assignFieldOfficer({
    required String reportId,
    required String fieldOfficerId,
  });
  Future<Either<Failure, bool>> provideAction({
    required String reportId,
    required DateTime? dueAction,
  });
  Future<Either<Failure, bool>> submitFieldCheck(SubmitFieldCheckParams params);
  Future<Either<Failure, bool>> submitFinalReport(
    SubmitFinalReportParams params,
  );
  Future<Either<Failure, int>> getUserReportAmount();
}
