part of 'edit_profile_bloc.dart';

enum EditProfileStatus { initial, loading, success, failure }

final class EditProfileState extends Equatable {
  final EditProfileStatus status;
  final String? errorMessage;

  bool get isInitial => status == EditProfileStatus.initial;
  bool get isLoading => status == EditProfileStatus.loading;
  bool get isSuccess => status == EditProfileStatus.success;
  bool get isFailure => status == EditProfileStatus.failure;

  const EditProfileState({
    this.status = EditProfileStatus.initial,
    this.errorMessage,
  });

  EditProfileState copyWith({EditProfileStatus? status, String? errorMessage}) {
    return EditProfileState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
