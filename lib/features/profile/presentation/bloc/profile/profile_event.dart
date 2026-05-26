part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

final class ProfileOpenned extends ProfileEvent {}

final class ProfileLogoutRequested extends ProfileEvent {}
