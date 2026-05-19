part of 'login_bloc.dart';

enum LoginStatus { initial, loading, success, failure }

final class LoginState extends Equatable {
  final LoginStatus status;
  final UserRole? role;
  final String? errorMessage;

  const LoginState({
    this.status = LoginStatus.initial,
    this.role,
    this.errorMessage,
  });

  LoginState copyWith({
    LoginStatus? status,
    UserRole? role,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      role: role ?? this.role,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, role, errorMessage];
}
