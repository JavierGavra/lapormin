import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/core/use_case/usecase.dart';
import 'package:lapormin/features/profile/domain/entities/profile.dart';
import 'package:lapormin/features/profile/domain/use_cases/get_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfile _getProfile;

  ProfileBloc({required GetProfile getProfile})
    : _getProfile = getProfile,
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
  }
}
