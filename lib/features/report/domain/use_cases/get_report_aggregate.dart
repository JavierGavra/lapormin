import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_case/usecase.dart';
import '../entities/report_aggregate.dart';
import '../repositories/report_repository.dart';

class GetReportAggregate
    implements UseCase<ReportAggregate, GetReportAggregateParams> {
  final ReportRepository repository;

  const GetReportAggregate(this.repository);

  @override
  Future<Either<Failure, ReportAggregate>> call(
    GetReportAggregateParams params,
  ) {
    return repository.getReportAggregate(params.id);
  }
}

class GetReportAggregateParams extends Equatable {
  final String id;

  const GetReportAggregateParams({required this.id});

  @override
  List<Object> get props => [id];
}
