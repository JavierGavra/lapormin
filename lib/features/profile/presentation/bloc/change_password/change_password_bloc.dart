import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/features/profile/domain/use_cases/change_password.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePassword _changePassword;

  ChangePasswordBloc({required ChangePassword changePasswordUseCase})
    : _changePassword = changePasswordUseCase,
      super(const ChangePasswordState()) {
    on<SubmitChangePassword>(_onSubmitChangePassword);
  }

  Future<void> _onSubmitChangePassword(
    SubmitChangePassword event,
    Emitter<ChangePasswordState> emit,
  ) async {
    emit(state.copyWith(status: ChangePasswordStatus.loading));

    final result = await _changePassword(
      ChangePasswordParams(
        oldPassword: event.oldPassword,
        newPassword: event.newPassword,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ChangePasswordStatus.failure,
          errorMessage: failure.message ?? 'Gagal mengubah kata sandi',
        ),
      ),
      (success) => emit(state.copyWith(status: ChangePasswordStatus.success)),
    );
  }
}
