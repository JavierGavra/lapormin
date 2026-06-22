import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/core/error/failures.dart';
import 'package:lapormin/core/use_case/usecase.dart';
import 'package:lapormin/features/report/domain/repositories/report_repository.dart';

class DeleteReport implements UseCase<bool, DeleteReportParams> {
  final ReportRepository repository;

  const DeleteReport(this.repository);

  @override
  Future<Either<Failure, bool>> call(DeleteReportParams params) {
    return repository.deleteReport(params.reportId);
  }
}

class DeleteReportParams extends Equatable {
  final String reportId;

  const DeleteReportParams({required this.reportId});

  @override
  List<Object> get props => [reportId];
}
