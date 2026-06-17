import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/features/report/domain/use_cases/get_user_report_amount.dart';

import '../../../../../core/use_case/usecase.dart';
import '../../../../auth/domain/use_cases/logout.dart';
import '../../../domain/entities/profile.dart';
import '../../../domain/use_cases/get_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserReportAmount _getUserReportAmount;
  final GetProfile _getProfile;
  final Logout _logout;

  ProfileBloc({
    required GetUserReportAmount getUserReportAmount,
    required GetProfile getProfile,
    required Logout logout,
  }) : _getUserReportAmount = getUserReportAmount,
       _logout = logout,
       _getProfile = getProfile,
       super(ProfileState()) {
    on<ProfileOpenned>(_onProfileOpenned);
    on<ProfileLogoutRequested>(_onProfileLogoutRequested);
  }

  void _emitFailure(Emitter<ProfileState> emit, String message) {
    emit(state.copyWith(status: ProfileStatus.failure, errorMessage: message));
  }

  Future<void> _onProfileOpenned(
    ProfileOpenned event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    final profile = await _getProfile(NoParams());

    await profile.fold(
      (failure) async => _emitFailure(emit, failure.message!),
      (profile) async {
        emit(state.copyWith(status: ProfileStatus.success, profile: profile));

        final reportAmount = await _getUserReportAmount(NoParams());
        reportAmount.fold(
          (failure) => _emitFailure(emit, failure.message!),
          (amount) => emit(
            state.copyWith(
              status: ProfileStatus.success,
              profile: state.profile?.copyWith(reportAmount: amount),
            ),
          ),
        );
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
