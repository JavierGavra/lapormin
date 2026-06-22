part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class AuthCheckRequested extends AuthEvent {}

final class _AuthLogoutRequested extends AuthEvent {}
