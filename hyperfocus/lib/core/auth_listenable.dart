import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperfocus/features/auth/domain/auth_state.dart';
import 'package:hyperfocus/features/auth/presentation/auth_provider.dart';

/// Bridges Riverpod state changes to GoRouter's refresh mechanism.
/// GoRouter needs a Listenable to know when to re-evaluate redirects.
/// This class listens to the auth provider and notifies GoRouter
/// without causing a full router rebuild.
class AuthNotifierListenable extends ChangeNotifier {
  late final ProviderSubscription<AppAuthState> _subscription;

  AuthNotifierListenable(Ref ref) {
    _subscription = ref.listen(authProvider, (_, __) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}