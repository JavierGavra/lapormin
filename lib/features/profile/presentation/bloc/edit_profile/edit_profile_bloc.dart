import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/features/profile/domain/use_cases/change_username.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final ChangeUsername _changeUsername;

  EditProfileBloc({required ChangeUsername changeUsername})
    : _changeUsername = changeUsername,
      super(EditProfileState()) {
    on<EditProfileUsernameChanged>(_onEditProfileUsernameChanged);
  }

  void _emitFailure(Emitter<EditProfileState> emit, String message) {
    emit(
      state.copyWith(status: EditProfileStatus.failure, errorMessage: message),
    );
  }

  Future<void> _onEditProfileUsernameChanged(
    EditProfileUsernameChanged event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(state.copyWith(status: EditProfileStatus.loading));
    final result = await _changeUsername(
      ChangeUsernameParams(newUsername: event.username),
    );

    result.fold(
      (failure) => _emitFailure(emit, failure.message!),
      (success) => emit(state.copyWith(status: EditProfileStatus.success)),
    );
  }
}
