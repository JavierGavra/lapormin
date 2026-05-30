import '../../../../core/constants/report_status_enum.dart';
import '../../domain/entities/report_status_log.dart';

class ReportStatusLogsModel extends ReportStatusLog {
  const ReportStatusLogsModel({
    required super.id,
    super.userId,
    required super.status,
    required super.createdAt,
  });

  factory ReportStatusLogsModel.fromMap(Map<String, dynamic> map) {
    return ReportStatusLogsModel(
      id: map['id'] as int,
      userId: map['user_id'] as String?,
      status: ReportStatus.fromString(map['status'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
