import 'package:supabase_flutter/supabase_flutter.dart';

sealed class AppAuthState {
  const AppAuthState();
}

class AuthInitial extends AppAuthState {
  const AuthInitial();
}

class AuthLoading extends AppAuthState {
  const AuthLoading();
}

class Authenticated extends AppAuthState {
  final User user;
  const Authenticated(this.user);
}

class Unauthenticated extends AppAuthState {
  const Unauthenticated();
}

class AuthError extends AppAuthState {
  final String message;
  const AuthError(this.message);
}