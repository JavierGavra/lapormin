part of 'notification_history_bloc.dart';

enum NotificationHistoryStatus { initial, loading, success, failure }

final class NotificationHistoryState extends Equatable {
  final NotificationHistoryStatus status;
  final List<NotificationHistory> notificationHistories;
  final String? errorMessage;

  const NotificationHistoryState({
    this.status = NotificationHistoryStatus.initial,
    this.notificationHistories = const [],
    this.errorMessage,
  });

  bool get isLoading => status == NotificationHistoryStatus.loading;
  bool get isSuccess => status == NotificationHistoryStatus.success;

  NotificationHistoryState copyWith({
    NotificationHistoryStatus? status,
    List<NotificationHistory>? notificationHistories,
    String? errorMessage,
  }) {
    return NotificationHistoryState(
      status: status ?? this.status,
      notificationHistories:
          notificationHistories ?? this.notificationHistories,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, notificationHistories, errorMessage];
}
