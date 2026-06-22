part of 'notification_permission_bloc.dart';

enum NotificationPermissionStatus { initial, loading, success, failure }

final class NotificationPermissionState extends Equatable {
  final NotificationPermissionStatus status;
  final String? errorMessage;

  const NotificationPermissionState({
    this.status = NotificationPermissionStatus.initial,
    this.errorMessage,
  });

  bool get isLoading => status == NotificationPermissionStatus.loading;

  @override
  List<Object?> get props => [status, errorMessage];
}
