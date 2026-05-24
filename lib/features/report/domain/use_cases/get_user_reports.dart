import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_case/usecase.dart';
import '../entities/report_summary.dart';
import '../repositories/report_repository.dart';

class GetUserReports implements UseCase<List<ReportSummary>, NoParams> {
  final ReportRepository repository;

  GetUserReports(this.repository);

  @override
  Future<Either<Failure, List<ReportSummary>>> call(NoParams params) {
    return repository.getUserReports();
  }
}
