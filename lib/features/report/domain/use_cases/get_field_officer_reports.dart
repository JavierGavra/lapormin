import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_case/usecase.dart';
import '../entities/report_summary.dart';
import '../params/report_filter_params.dart';
import '../repositories/report_repository.dart';

class GetFieldOfficerReports
    implements UseCase<List<ReportSummary>, ReportFilterParams> {
  final ReportRepository repository;

  GetFieldOfficerReports(this.repository);

  @override
  Future<Either<Failure, List<ReportSummary>>> call(ReportFilterParams params) {
    return repository.getFieldOfficerReports(params);
  }
}
