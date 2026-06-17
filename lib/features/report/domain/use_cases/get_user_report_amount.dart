import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_case/usecase.dart';
import '../repositories/report_repository.dart';

class GetUserReportAmount implements UseCase<int, NoParams> {
  final ReportRepository repository;

  GetUserReportAmount(this.repository);

  @override
  Future<Either<Failure, int>> call(NoParams params) {
    return repository.getUserReportAmount();
  }
}
