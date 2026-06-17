import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/usecase.dart';
import '../entities/report_statistics.dart';
import '../repositories/report_repository.dart';

class GetAdminReportStatistics implements UseCase<ReportStatistics, NoParams> {
  final ReportRepository repository;

  GetAdminReportStatistics(this.repository);

  @override
  Future<Either<Failure, ReportStatistics>> call(NoParams params) {
    return repository.getAdminReportStatistics();
  }
}
