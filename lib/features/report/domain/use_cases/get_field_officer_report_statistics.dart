import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/usecase.dart';
import '../entities/field_officer_statistics.dart';
import '../repositories/report_repository.dart';

class GetFieldOfficerReportStatistics
    implements UseCase<FieldOfficerStatistics, NoParams> {
  final ReportRepository repository;

  GetFieldOfficerReportStatistics(this.repository);

  @override
  Future<Either<Failure, FieldOfficerStatistics>> call(NoParams params) {
    return repository.getFieldOfficerReportStatistics();
  }
}
