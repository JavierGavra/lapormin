import 'package:equatable/equatable.dart';

import 'field_check.dart';
import 'final_report.dart';
import 'report.dart';

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
