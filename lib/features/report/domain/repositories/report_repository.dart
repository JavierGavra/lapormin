import 'package:dartz/dartz.dart';
import 'package:lapormin/core/error/failures.dart';
import 'package:lapormin/features/report/domain/entities/report.dart';
import 'package:lapormin/features/report/domain/entities/report_summary.dart';
import 'package:lapormin/features/report/domain/params/report_filter_params.dart';
import 'package:lapormin/features/report/domain/use_cases/submit_report.dart';

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
  Future<Either<Failure, bool>> deleteReport(String id);
}
