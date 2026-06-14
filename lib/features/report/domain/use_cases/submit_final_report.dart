import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_case/usecase.dart';
import '../repositories/report_repository.dart';

class SubmitFinalReport implements UseCase<bool, SubmitFinalReportParams> {
  final ReportRepository repository;

  const SubmitFinalReport(this.repository);

  @override
  Future<Either<Failure, bool>> call(SubmitFinalReportParams params) async {
    return await repository.submitFinalReport(params);
  }
}

class SubmitFinalReportParams extends Equatable {
  final String reportId;
  final String description;
  final List<String> evidences;

  const SubmitFinalReportParams({
    required this.reportId,
    required this.description,
    required this.evidences,
  });

  @override
  List<Object> get props => [reportId, description, evidences];
}
