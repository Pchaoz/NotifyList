import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperfocus/core/auth_listenable.dart';
import 'package:hyperfocus/features/auth/domain/auth_state.dart';
import 'package:hyperfocus/features/auth/presentation/auth_provider.dart';
import 'package:hyperfocus/features/auth/presentation/login_screen.dart';
import 'package:hyperfocus/features/auth/presentation/register_screen.dart';
import 'package:hyperfocus/features/inbox/presentation/inbox_screen.dart';
import 'package:hyperfocus/features/today/presentation/today_screen.dart';
import 'package:hyperfocus/features/calendar/presentation/calendar_screen.dart';
import 'package:hyperfocus/features/gamification/presentation/stats_screen.dart';
import 'package:hyperfocus/features/settings/presentation/settings_screen.dart';
import 'package:hyperfocus/shared/widgets/app_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authListenable = AuthNotifierListenable(ref);

  ref.onDispose(() => authListenable.dispose());

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    // Re-evaluate redirects when auth state changes,
    // without rebuilding the entire router.
    refreshListenable: authListenable,
    redirect: (context, state) {
      // Read current auth state at redirect time.
      final authState = ref.read(authProvider);
      final isAuth = authState is Authenticated;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!isAuth && !isAuthRoute) return '/login';
      if (isAuth && isAuthRoute) return '/inbox';

      return null;
    },
    routes: [
      // Auth routes (outside shell, no bottom nav).
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Main app shell with bottom navigation.
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/inbox',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: InboxScreen(),
            ),
          ),
          GoRoute(
            path: '/today',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TodayScreen(),
            ),
          ),
          GoRoute(
            path: '/calendar',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CalendarScreen(),
            ),
          ),
          GoRoute(
            path: '/stats',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: StatsScreen(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
        ],
      ),
    ],
  );
});