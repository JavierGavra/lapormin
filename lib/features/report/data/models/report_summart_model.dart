import 'package:lapormin/core/constants/report_status_enum.dart';
import 'package:lapormin/features/report/domain/entities/report_summary.dart';

class ReportSummartModel extends ReportSummary {
  const ReportSummartModel({
    required super.id,
    required super.title,
    required super.shortAdddress,
    required super.category,
    required super.evidence,
    required super.createdAt,
    required super.status,
    required super.dueDate,
  });

  factory ReportSummartModel.fromMap(Map<String, dynamic> map) {
    return ReportSummartModel(
      id: map['id'] as String,
      title: map['title'] as String,
      shortAdddress: map['shortAddress'] as String,
      category: map['category'] as String,
      evidence: map['evidence'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      status: ReportStatus.values.byName(map['status'] as String),
      dueDate: DateTime.parse(map['dueDate'] as String),
    );
  }
}
