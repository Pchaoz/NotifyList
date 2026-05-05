import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:hyperfocus/features/auth/data/auth_repository.dart';
import 'package:hyperfocus/features/auth/domain/auth_state.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, AppAuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AppAuthState> {
  final AuthRepository _repo;
  StreamSubscription<sb.AuthState>? _subscription;

  AuthNotifier(this._repo) : super(const AuthInitial()) {
    _init();
  }

  void _init() {
    // Check if there is already a session on startup.
    final user = _repo.currentUser;
    if (user != null) {
      state = Authenticated(user);
    } else {
      state = const Unauthenticated();
    }

    // Listen for auth changes (login, logout, token refresh).
    _subscription = _repo.onAuthStateChange.listen((authState) {
      final session = authState.session;
      if (session != null) {
        state = Authenticated(session.user);
      } else {
        state = const Unauthenticated();
      }
    });
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();
    try {
      await _repo.signUp(email: email, password: password);
      // After signup with email verification, the user is NOT
      // automatically logged in. We go back to unauthenticated
      // so the UI can show the "check your email" message.
      state = const Unauthenticated();
    } on sb.AuthException catch (e) {
      state = AuthError(e.message);
    } catch (e) {
      state = AuthError('Error inesperado: $e');
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();
    try {
      await _repo.signIn(email: email, password: password);
      // The auth state listener handles the transition to Authenticated.
    } on sb.AuthException catch (e) {
      state = AuthError(e.message);
    } catch (e) {
      state = AuthError('Error inesperado: $e');
    }
  }

  Future<void> signOut() async {
    await _repo.signOut();
    // The auth state listener handles the transition to Unauthenticated.
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}