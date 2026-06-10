part of 'notification_history_bloc.dart';

sealed class NotificationHistoryEvent extends Equatable {
  const NotificationHistoryEvent();

  @override
  List<Object> get props => [];
}

final class NotificationHistoryOpened extends NotificationHistoryEvent {}
