import 'package:equatable/equatable.dart';

import '../../../../core/constants/notification_type.dart';

class NotificationHistory extends Equatable {
  final int id;
  final String userId;
  final String content;
  final bool isRead;
  final String? reportId;
  final NotificationType type;
  final DateTime createdAt;

  const NotificationHistory({
    required this.id,
    required this.userId,
    required this.type,
    required this.content,
    required this.isRead,
    this.reportId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    type,
    content,
    isRead,
    reportId,
    createdAt,
  ];
}
