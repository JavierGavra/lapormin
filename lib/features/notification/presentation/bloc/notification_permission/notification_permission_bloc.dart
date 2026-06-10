import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/services/push_notification/push_notification_service.dart';

part 'notification_permission_event.dart';
part 'notification_permission_state.dart';

class NotificationPermissionBloc
    extends Bloc<NotificationPermissionEvent, NotificationPermissionState> {
  final PushNotificationService _pushNotificationService;

  NotificationPermissionBloc({
    required PushNotificationService pushNotificationService,
  }) : _pushNotificationService = pushNotificationService,
       super(const NotificationPermissionState()) {
    on<NotificationPermissionRequested>(_onNotificationPermissionRequested);
  }

  Future<void> _onNotificationPermissionRequested(
    NotificationPermissionRequested event,
    Emitter<NotificationPermissionState> emit,
  ) async {
    emit(
      const NotificationPermissionState(
        status: NotificationPermissionStatus.loading,
      ),
    );

    final response = await _pushNotificationService.requestPermission();

    if (response == null || response.isEmpty) {
      emit(
        const NotificationPermissionState(
          status: NotificationPermissionStatus.failure,
          errorMessage:
              'Izin notifikasi ditolak, buka pengaturan untuk mengaktifkan kembali.',
        ),
      );
      return;
    }

    emit(
      const NotificationPermissionState(
        status: NotificationPermissionStatus.success,
      ),
    );
  }
}
