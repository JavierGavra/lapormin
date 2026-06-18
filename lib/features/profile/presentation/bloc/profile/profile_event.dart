part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

final class ProfileOpenned extends ProfileEvent {}

final class ProfilePhotoUpdateRequested extends ProfileEvent {
  final File imageFile;
  final String extension;

  const ProfilePhotoUpdateRequested({
    required this.imageFile,
    required this.extension,
  });

  @override
  List<Object> get props => [imageFile, extension];
}

final class ProfileLogoutRequested extends ProfileEvent {}
