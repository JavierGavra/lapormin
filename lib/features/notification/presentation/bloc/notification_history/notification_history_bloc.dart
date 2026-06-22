import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/features/notification/domain/use_cases/mark_all_as_read.dart';

import '../../../../../core/use_case/usecase.dart';
import '../../../domain/entities/notification_history.dart';
import '../../../domain/use_cases/get_notification_history.dart';

part 'notification_history_event.dart';
part 'notification_history_state.dart';

class NotificationHistoryBloc
    extends Bloc<NotificationHistoryEvent, NotificationHistoryState> {
  final GetNotificationHistory _getNotificationHistory;
  final MarkAllAsRead _markAllAsRead;

  NotificationHistoryBloc({
    required GetNotificationHistory getNotificationHistory,
    required MarkAllAsRead markAllAsRead,
  }) : _getNotificationHistory = getNotificationHistory,
       _markAllAsRead = markAllAsRead,
       super(const NotificationHistoryState()) {
    on<NotificationHistoryOpened>(_onNotificationHistoryOpened);
    on<NotificationHistoryReadAll>(_onNotificationHistoryReadAll);
  }

  Future<void> _onNotificationHistoryOpened(
    NotificationHistoryOpened event,
    Emitter<NotificationHistoryState> emit,
  ) async {
    emit(state.copyWith(status: NotificationHistoryStatus.loading));

    final result = await _getNotificationHistory(NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: NotificationHistoryStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (histories) => emit(
        state.copyWith(
          status: NotificationHistoryStatus.success,
          notificationHistories: histories,
        ),
      ),
    );
  }

  Future<void> _onNotificationHistoryReadAll(
    NotificationHistoryReadAll event,
    Emitter<NotificationHistoryState> emit,
  ) async {
    final result = await _markAllAsRead(NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: NotificationHistoryStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (updatedHistories) => {},
    );
  }
}
