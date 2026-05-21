import 'package:dartz/dartz.dart';
import 'package:lapormin/core/error/failures.dart';
import 'package:lapormin/features/report/domain/use_cases/submit_report.dart';

abstract interface class ReportRepository {
  Future<Either<Failure, bool>> submitReport(SubmitReportParams params);
  // Future<Either<Failure, bool>> getReportsInformant();
}
