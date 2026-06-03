import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_case/usecase.dart';
import '../repositories/report_repository.dart';

class ProvideAction implements UseCase<bool, ProvideActionParams> {
  final ReportRepository repository;

  const ProvideAction(this.repository);

  @override
  Future<Either<Failure, bool>> call(ProvideActionParams params) async {
    return repository.provideAction(
      reportId: params.reportId,
      dueAction: params.dueAction,
    );
  }
}

class ProvideActionParams extends Equatable {
  final String reportId;
  final DateTime? dueAction;

  const ProvideActionParams({required this.reportId, this.dueAction});

  @override
  List<Object?> get props => [reportId, dueAction];
}
