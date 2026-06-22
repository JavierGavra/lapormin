import 'package:dartz/dartz.dart';

import '../../../../core/constants/report_status_enum.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/usecase.dart';
import '../entities/report_summary.dart';
import '../params/report_filter_params.dart';
import '../repositories/report_repository.dart';

class GetPublicReports
    implements UseCase<List<ReportSummary>, ReportFilterParams> {
  final ReportRepository repository;

  GetPublicReports(this.repository);

  @override
  Future<Either<Failure, List<ReportSummary>>> call(ReportFilterParams params) {
    if (params.statuses.contains(ReportStatus.pending)) {
      return Future.value(
        Left(ValidationFailure("Anda tidak memiliki akses untuk fitur ini.")),
      );
    }

    return repository.getPublicReports(params);
  }
}
