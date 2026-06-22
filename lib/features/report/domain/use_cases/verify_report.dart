import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/constants/report_status_enum.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/usecase.dart';
import '../entities/report.dart';
import '../repositories/report_repository.dart';

class VerifyReport implements UseCase<Report, VerifyReportParams> {
  final ReportRepository repository;

  const VerifyReport(this.repository);

  @override
  Future<Either<Failure, Report>> call(VerifyReportParams params) async {
    return repository.updateReportStatus(
      id: params.id,
      status: ReportStatus.verified,
    );
  }
}

class VerifyReportParams extends Equatable {
  final String id;

  const VerifyReportParams({required this.id});

  @override
  List<Object?> get props => [id];
}
