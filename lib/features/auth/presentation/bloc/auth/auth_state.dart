part of 'auth_bloc.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

final class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;

  const AuthState({this.status = AuthStatus.initial, this.user});

  @override
  List<Object?> get props => [status, user];
}
