part of 'register_bloc.dart';

enum RegisterStatus { initial, loading, next, previous, success, failure }

final class RegisterState extends Equatable {
  final RegisterStatus status;
  final int currentStep;
  final String? username, phone, password, otp;
  final String? errorMessage;

  const RegisterState.initial() : this(status: RegisterStatus.initial);

  const RegisterState({
    this.status = RegisterStatus.initial,
    this.currentStep = 1,
    this.username,
    this.phone,
    this.password,
    this.otp,
    this.errorMessage,
  });

  RegisterState copyWith({
    RegisterStatus? status,
    int? currentStep,
    String? username,
    String? phone,
    String? password,
    String? otp,
    String? errorMessage,
  }) {
    return RegisterState(
      status: status ?? this.status,
      currentStep: currentStep ?? this.currentStep,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      otp: otp ?? this.otp,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    currentStep,
    username,
    phone,
    password,
    otp,
    errorMessage,
  ];
}
