import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/constants/report_status_enum.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/usecase.dart';
import '../entities/report.dart';
import '../repositories/report_repository.dart';

class RejectReport implements UseCase<Report, RejectReportParams> {
  final ReportRepository repository;

  const RejectReport(this.repository);

  @override
  Future<Either<Failure, Report>> call(RejectReportParams params) async {
    return repository.updateReportStatus(
      id: params.id,
      status: ReportStatus.rejected,
    );
  }
}

class RejectReportParams extends Equatable {
  final String id;

  const RejectReportParams({required this.id});

  @override
  List<Object?> get props => [id];
}
