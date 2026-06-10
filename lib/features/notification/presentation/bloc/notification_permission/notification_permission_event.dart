part of 'notification_permission_bloc.dart';

sealed class NotificationPermissionEvent extends Equatable {
  const NotificationPermissionEvent();

  @override
  List<Object> get props => [];
}

final class NotificationPermissionRequested
    extends NotificationPermissionEvent {
  const NotificationPermissionRequested();
}
