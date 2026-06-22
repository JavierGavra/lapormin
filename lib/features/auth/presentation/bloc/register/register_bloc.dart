import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/use_cases/send_otp.dart';
import '../../../domain/use_cases/verify_otp.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final SendOtp sendOtp;
  final VerifyOtp verifyOtp;

  RegisterBloc({required this.sendOtp, required this.verifyOtp})
    : super(RegisterState.initial()) {
    on<RegisterUsernameSubmit>(_onRegisterUsernameSubmit);
    on<RegisterPhoneSubmit>(_onRegisterPhoneSubmit);
    on<RegisterPasswordSubmit>(_onRegisterPasswordSubmit);
    on<RegisterOtpSubmit>(_onRegisterOtpSubmit);
    on<RegisterPreviousStep>(_onRegisterPreviousStep);
  }

  Future<void> _onRegisterUsernameSubmit(
    RegisterUsernameSubmit event,
    Emitter<RegisterState> emit,
  ) async {
    emit(
      state.copyWith(
        username: event.username,
        status: RegisterStatus.next,
        currentStep: state.currentStep + 1,
      ),
    );
  }

  Future<void> _onRegisterPhoneSubmit(
    RegisterPhoneSubmit event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: RegisterStatus.loading));

    await Future.delayed(const Duration(seconds: 1));

    emit(
      state.copyWith(
        phone: event.phone,
        status: RegisterStatus.next,
        currentStep: state.currentStep + 1,
      ),
    );
  }

  Future<void> _onRegisterPasswordSubmit(
    RegisterPasswordSubmit event,
    Emitter<RegisterState> emit,
  ) async {
    final username = state.username ?? '';
    final phone = state.phone ?? '';

    if (username.isEmpty || phone.isEmpty) {
      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          errorMessage: 'Data tidak lengkap. Silakan ulangi.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(status: RegisterStatus.loading, password: event.password),
    );

    final result = await sendOtp(
      SendOtpParams(
        username: state.username!,
        phone: state.phone!,
        password: event.password,
      ),
    );

    result.fold(
      (fail) => emit(
        state.copyWith(
          status: RegisterStatus.failure,
          errorMessage: fail.message,
        ),
      ),
      (success) => emit(
        state.copyWith(
          status: RegisterStatus.next,
          currentStep: state.currentStep + 1,
        ),
      ),
    );
  }

  Future<void> _onRegisterOtpSubmit(
    RegisterOtpSubmit event,
    Emitter<RegisterState> emit,
  ) async {
    final phone = state.phone ?? '';

    if (phone.isEmpty) {
      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          errorMessage: 'Nomor telepon tidak valid.',
        ),
      );
      return;
    }

    emit(state.copyWith(status: RegisterStatus.loading, otp: event.otp));

    final result = await verifyOtp(
      VerifyOtpParams(phone: state.phone!, otp: event.otp),
    );

    result.fold(
      (fail) => emit(
        state.copyWith(
          status: RegisterStatus.failure,
          errorMessage: fail.message,
        ),
      ),
      (success) => emit(state.copyWith(status: RegisterStatus.success)),
    );
  }

  Future<void> _onRegisterPreviousStep(
    RegisterPreviousStep event,
    Emitter<RegisterState> emit,
  ) async {
    RegisterState newState = state.copyWith(
      currentStep: state.currentStep - 1,
      status: RegisterStatus.previous,
    );

    if (state.currentStep == 3) {
      newState = newState.copyWith(password: "");
    } else if (state.currentStep == 2) {
      newState = newState.copyWith(phone: "");
    }

    emit(newState);
  }
}
