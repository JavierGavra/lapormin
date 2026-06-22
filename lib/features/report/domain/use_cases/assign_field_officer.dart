import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_case/usecase.dart';
import '../repositories/report_repository.dart';

class AssignFieldOfficer implements UseCase<bool, AssignFieldOfficerParams> {
  final ReportRepository repository;

  const AssignFieldOfficer(this.repository);

  @override
  Future<Either<Failure, bool>> call(AssignFieldOfficerParams params) async {
    return repository.assignFieldOfficer(
      reportId: params.reportId,
      fieldOfficerId: params.fieldOfficerId,
    );
  }
}

class AssignFieldOfficerParams extends Equatable {
  final String reportId;
  final String fieldOfficerId;

  const AssignFieldOfficerParams({
    required this.reportId,
    required this.fieldOfficerId,
  });

  @override
  List<Object?> get props => [reportId, fieldOfficerId];
}
