import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterState.initial()) {
    on<RegisterUsernameSubmit>(_onDataSubmit);
    on<RegisterPhoneSubmit>(_onDataSubmit);
    on<RegisterPasswordSubmit>(_onDataSubmit);
    on<RegisterPreviousStep>(_onRegisterPreviousStep);
  }

  Future<void> _onDataSubmit(
    RegisterEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: RegisterStatus.loading));
    RegisterState newState = state.copyWith(
      status: RegisterStatus.next,
      currentStep: state.currentStep + 1,
    );

    if (event is RegisterUsernameSubmit) {
      newState = newState.copyWith(username: event.username);
    } else if (event is RegisterPhoneSubmit) {
      // do phone database checking
      await Future.delayed(const Duration(seconds: 1));
      newState = newState.copyWith(phone: event.phone);
    } else if (event is RegisterPasswordSubmit) {
      // send OTP to user's phone number
      await Future.delayed(const Duration(seconds: 1));
      newState = newState.copyWith(password: event.password);
    }
    emit(newState);
  }

  Future<void> _onRegisterPreviousStep(
    RegisterPreviousStep event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: RegisterStatus.initial));
    RegisterState newState = state.copyWith(
      currentStep: state.currentStep - 1,
      status: RegisterStatus.previous,
    );

    switch (state.currentStep) {
      case 2:
        newState = newState.copyWith(phone: "");
        break;
      case 3:
        newState = newState.copyWith(password: "");
        break;
    }

    emit(newState);
  }
}
