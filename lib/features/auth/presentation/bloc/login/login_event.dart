part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {}

final class LoginSubmitted extends LoginEvent {
  final String phone;
  final String password;

  LoginSubmitted({required this.phone, required this.password});

  @override
  List<Object?> get props => [phone, password];
}
