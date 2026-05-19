import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/core/constants/user_role_enum.dart';
import 'package:lapormin/features/auth/domain/use_cases/login.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Login _login;

  LoginBloc({required Login login}) : _login = login, super(LoginState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));
    final result = await _login(
      LoginParams(phoneNumber: event.phone, password: event.password),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (user) =>
          emit(state.copyWith(status: LoginStatus.success, role: user.role)),
    );
  }
}
