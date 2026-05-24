import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/core/error/failures.dart';
import 'package:lapormin/core/use_case/usecase.dart';
import 'package:lapormin/features/report/domain/entities/report.dart';
import 'package:lapormin/features/report/domain/repositories/report_repository.dart';

class GetReport implements UseCase<Report, GetReportParams> {
  final ReportRepository repository;

  const GetReport(this.repository);

  @override
  Future<Either<Failure, Report>> call(GetReportParams params) {
    return repository.getReport(params.id);
  }
}

class GetReportParams extends Equatable {
  final String id;

  const GetReportParams({required this.id});

  @override
  List<Object> get props => [id];
}
