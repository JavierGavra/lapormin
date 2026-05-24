import 'package:equatable/equatable.dart';
import 'package:lapormin/features/report/domain/entities/field_check.dart';
import 'package:lapormin/features/report/domain/entities/final_report.dart';
import 'package:lapormin/features/report/domain/entities/report.dart';

class ReportAggregate extends Equatable {
  final Report report;
  final FieldCheck? fieldCheck;
  final FinalReport? finalReport;

  const ReportAggregate({
    required this.report,
    this.fieldCheck,
    this.finalReport,
  });

  @override
  List<Object?> get props => [report, fieldCheck, finalReport];
}
