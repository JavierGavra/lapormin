import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:lapormin/core/use_case/usecase.dart';
import 'package:lapormin/features/auth/domain/entities/user.dart';
import 'package:lapormin/features/auth/domain/use_cases/get_current_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetCurrentUser _getCurrentUser;
  final SupabaseClient _supabase;

  AuthBloc({
    required GetCurrentUser getCurrentUser,
    required SupabaseClient supabase,
  }) : _getCurrentUser = getCurrentUser,
       _supabase = supabase,
       super(AuthState()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<_AuthLogoutRequested>(_onAuthLogoutRequested);

    _listenToSupabaseAuthState();
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      final session = _supabase.auth.currentSession;

      if (session != null) {
        final result = await _getCurrentUser(NoParams());
        result.fold(
          (failure) => emit(AuthState(status: AuthStatus.unauthenticated)),
          (user) {
            emit(AuthState(status: AuthStatus.authenticated, user: user));
          },
        );
      } else {
        emit(AuthState(status: AuthStatus.unauthenticated));
      }
    } catch (_) {
      emit(AuthState(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> _onAuthLogoutRequested(
    _AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState(status: AuthStatus.unauthenticated));
  }

  void _listenToSupabaseAuthState() {
    _supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedOut) {
        if (kDebugMode) print("=== User signed out ===");
        add(_AuthLogoutRequested());
      }
    });
  }
}
