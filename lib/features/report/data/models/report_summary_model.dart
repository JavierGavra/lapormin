import '../../../../core/constants/report_status_enum.dart';
import '../../domain/entities/report_summary.dart';

class ReportSummaryModel extends ReportSummary {
  const ReportSummaryModel({
    required super.id,
    required super.title,
    required super.shortAdddress,
    required super.category,
    required super.evidence,
    required super.createdAt,
    required super.status,
    super.dueAction,
  });

  factory ReportSummaryModel.fromMap(Map<String, dynamic> map) {
    return ReportSummaryModel(
      id: map['id'] as String,
      title: map['title'] as String,
      shortAdddress: (map['address'] as String).split(',').first,
      category: map['category'] as String,
      evidence: map['evidence'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      status: ReportStatus.fromString(map['status'] as String),
      dueAction: map['due_action'] != null
          ? DateTime.parse(map['due_action'] as String)
          : null,
    );
  }
}
