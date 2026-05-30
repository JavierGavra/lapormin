import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/report.dart';
import '../entities/report_aggregate.dart';
import '../entities/report_summary.dart';
import '../params/report_filter_params.dart';
import '../use_cases/submit_report.dart';

abstract interface class ReportRepository {
  Future<Either<Failure, bool>> submitReport(SubmitReportParams params);
  Future<Either<Failure, List<ReportSummary>>> getUserReports();
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
  Future<Either<Failure, bool>> deleteReport(String id);
}
