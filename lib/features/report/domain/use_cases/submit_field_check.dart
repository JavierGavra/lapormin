import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/core/error/failures.dart';
import 'package:lapormin/core/use_case/usecase.dart';
import 'package:lapormin/features/report/domain/repositories/report_repository.dart';

class SubmitFieldCheck implements UseCase<bool, SubmitFieldCheckParams> {
  final ReportRepository repository;

  const SubmitFieldCheck(this.repository);

  @override
  Future<Either<Failure, bool>> call(SubmitFieldCheckParams params) {
    return repository.submitFieldCheck(params);
  }
}

class SubmitFieldCheckParams extends Equatable {
  final String fieldCheckId;
  final String description;
  final List<String> evidences;

  const SubmitFieldCheckParams({
    required this.fieldCheckId,
    required this.description,
    required this.evidences,
  });

  @override
  List<Object?> get props => [fieldCheckId, description, evidences];
}
