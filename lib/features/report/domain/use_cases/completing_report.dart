import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/constants/report_status_enum.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/usecase.dart';
import '../entities/report.dart';
import '../repositories/report_repository.dart';

class CompletingReport implements UseCase<Report, CompletingReportParams> {
  final ReportRepository repository;

  const CompletingReport(this.repository);

  @override
  Future<Either<Failure, Report>> call(CompletingReportParams params) async {
    return repository.updateReportStatus(
      id: params.id,
      status: ReportStatus.done,
    );
  }
}

class CompletingReportParams extends Equatable {
  final String id;

  const CompletingReportParams({required this.id});

  @override
  List<Object?> get props => [id];
}
