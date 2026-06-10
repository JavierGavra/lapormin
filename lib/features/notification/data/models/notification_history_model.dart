import '../../../../core/constants/notification_type.dart';
import '../../domain/entities/notification_history.dart';

class NotificationHistoryModel extends NotificationHistory {
  const NotificationHistoryModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.content,
    required super.isRead,
    super.reportId,
    required super.createdAt,
  });

  factory NotificationHistoryModel.fromMap(Map<String, dynamic> data) {
    return NotificationHistoryModel(
      id: data['id'],
      userId: data['user_id'],
      type: NotificationType.fromString(data['type']),
      content: data['content'],
      isRead: data['is_read'],
      reportId: data['report_id'],
      createdAt: DateTime.parse(data['created_at']),
    );
  }
}
