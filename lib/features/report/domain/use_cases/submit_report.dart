import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/core/constants/report_category_enum.dart';
import 'package:lapormin/core/error/failures.dart';
import 'package:lapormin/core/use_case/usecase.dart';
import 'package:lapormin/features/report/domain/repositories/report_repository.dart';

class SubmitReport implements UseCase<bool, SubmitReportParams> {
  final ReportRepository repository;

  const SubmitReport(this.repository);

  @override
  Future<Either<Failure, bool>> call(params) async {
    return repository.submitReport(params);
  }
}

class SubmitReportParams extends Equatable {
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final ReportCategory category;
  final List<String> evidences;

  const SubmitReportParams({
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.evidences,
  });

  @override
  List<Object?> get props => [
    title,
    description,
    latitude,
    longitude,
    category,
    evidences,
  ];
}
