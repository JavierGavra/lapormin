import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/use_case/usecase.dart';
import '../../../../auth/domain/use_cases/logout.dart';
import '../../../domain/entities/profile.dart';
import '../../../domain/use_cases/get_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfile _getProfile;
  final Logout _logout;

  ProfileBloc({required GetProfile getProfile, required Logout logout})
    : _logout = logout,
      _getProfile = getProfile,
      super(ProfileState()) {
    on<ProfileOpenned>(_onProfileOpenned);
    on<ProfileLogoutRequested>(_onProfileLogoutRequested);
  }

  Future<void> _onProfileOpenned(
    ProfileOpenned event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    final profile = await _getProfile(NoParams());

    profile.fold(
      (failure) => emit(state.copyWith(status: ProfileStatus.failure)),
      (profile) {
        emit(state.copyWith(status: ProfileStatus.success, profile: profile));
      },
    );
  }

  Future<void> _onProfileLogoutRequested(
    ProfileLogoutRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    final result = await _logout(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(status: ProfileStatus.failure)),
      (success) => emit(state.copyWith(status: ProfileStatus.success)),
    );
  }
}
