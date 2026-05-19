part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();
}

final class RegisterUsernameSubmit extends RegisterEvent {
  final String username;

  const RegisterUsernameSubmit(this.username);

  @override
  List<Object?> get props => [username];
}

final class RegisterPhoneSubmit extends RegisterEvent {
  final String phone;

  const RegisterPhoneSubmit(this.phone);

  @override
  List<Object?> get props => [phone];
}

final class RegisterPasswordSubmit extends RegisterEvent {
  final String password;

  const RegisterPasswordSubmit(this.password);

  @override
  List<Object?> get props => [password];
}

final class RegisterOtpSubmit extends RegisterEvent {
  final String otp;

  const RegisterOtpSubmit(this.otp);

  @override
  List<Object?> get props => [otp];
}

final class RegisterPreviousStep extends RegisterEvent {
  const RegisterPreviousStep();

  @override
  List<Object?> get props => [];
}
