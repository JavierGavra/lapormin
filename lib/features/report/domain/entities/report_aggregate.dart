import 'package:equatable/equatable.dart';

import 'field_check.dart';
import 'final_report.dart';
import 'report.dart';
import 'report_status_log.dart';

class ReportAggregate extends Equatable {
  final Report report;
  final FieldCheck? fieldCheck;
  final FinalReport? finalReport;
  final List<ReportStatusLog> statusLogs;

  const ReportAggregate({
    required this.report,
    this.fieldCheck,
    this.finalReport,
    required this.statusLogs,
  });

  @override
  List<Object?> get props => [report, fieldCheck, finalReport, statusLogs];
}
