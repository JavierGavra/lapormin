import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SupabaseClient _supabase;

  AuthBloc({required SupabaseClient supabase})
    : _supabase = supabase,
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
        emit(AuthState(status: AuthStatus.authenticated));
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
