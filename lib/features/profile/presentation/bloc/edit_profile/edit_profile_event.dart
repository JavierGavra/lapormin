part of 'edit_profile_bloc.dart';

sealed class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object> get props => [];
}

final class EditProfileUsernameChanged extends EditProfileEvent {
  final String username;

  const EditProfileUsernameChanged(this.username);

  @override
  List<Object> get props => [username];
}
