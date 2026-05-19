part of 'auth_bloc.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

final class AuthState extends Equatable {
  final AuthStatus status;

  const AuthState({this.status = AuthStatus.initial});

  @override
  List<Object> get props => [status];
}
