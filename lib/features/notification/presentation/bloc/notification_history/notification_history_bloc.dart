import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/use_case/usecase.dart';
import '../../../domain/entities/notification_history.dart';
import '../../../domain/use_cases/get_notification_history.dart';

part 'notification_history_event.dart';
part 'notification_history_state.dart';

class NotificationHistoryBloc
    extends Bloc<NotificationHistoryEvent, NotificationHistoryState> {
  final GetNotificationHistory _getNotificationHistory;

  NotificationHistoryBloc({
    required GetNotificationHistory getNotificationHistory,
  }) : _getNotificationHistory = getNotificationHistory,
       super(const NotificationHistoryState()) {
    on<NotificationHistoryOpened>(_onNotificationHistoryOpened);
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
}
