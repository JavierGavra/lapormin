import '../../domain/entities/report_aggregate.dart';
import 'field_check_model.dart';
import 'final_report_model.dart';
import 'report_model.dart';
import 'report_status_logs_model.dart';

class ReportAggregateModel extends ReportAggregate {
  const ReportAggregateModel({
    required super.report,
    required super.statusLogs,
    super.fieldCheck,
    super.finalReport,
  });

  factory ReportAggregateModel.fromMap(Map<String, dynamic> data) {
    return ReportAggregateModel(
      report: ReportModel.fromMap(data),
      statusLogs: (data['report_status_logs'] as List)
          .map((e) => ReportStatusLogsModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      fieldCheck: data['field_check'] != null
          ? FieldCheckModel.fromMap(data['field_check'] as Map<String, dynamic>)
          : null,
      finalReport: data['final_report'] != null
          ? FinalReportModel.fromMap(
              data['final_report'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}
