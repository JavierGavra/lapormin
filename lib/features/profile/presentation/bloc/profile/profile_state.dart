part of 'profile_bloc.dart';

enum ProfileStatus {
  initial,
  loading,
  avatarLoading,
  avatarSuccess,
  success,
  failure,
}

final class ProfileState extends Equatable {
  final ProfileStatus status;
  final Profile? profile;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.errorMessage,
  });

  bool get isSuccess =>
      status == ProfileStatus.success || status == ProfileStatus.avatarSuccess;

  ProfileState copyWith({
    ProfileStatus? status,
    Profile? profile,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage];
}
