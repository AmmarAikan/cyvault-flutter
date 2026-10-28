import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/auth_page.dart';
import '../features/breach_check/presentation/breach_check_page.dart';
import '../features/help/presentation/info_page.dart';
import '../features/shell/presentation/main_shell.dart';
import 'providers.dart';

String? authGuardRedirect({required bool unlocked, required String location}) {
  final onAuth = location == '/auth';
  if (!unlocked) return onAuth ? null : '/auth';
  if (onAuth) return '/home';
  return null;
}

final routerProvider = Provider<GoRouter>((ref) {
  final session = ref.watch(sessionProvider);
  return GoRouter(
    initialLocation: '/auth',
    refreshListenable: session,
    redirect: (context, state) => authGuardRedirect(
      unlocked: session.isUnlocked,
      location: state.matchedLocation,
    ),
    routes: <RouteBase>[
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const MainShell(),
      ),
      GoRoute(
        path: '/breach',
        name: 'breach',
        builder: (context, state) => const BreachCheckPage(),
      ),
      GoRoute(
        path: '/help',
        name: 'help',
        builder: (context, state) => const InfoPage(kind: InfoKind.help),
      ),
      GoRoute(
        path: '/security',
        name: 'security',
        builder: (context, state) => const InfoPage(kind: InfoKind.security),
      ),
      GoRoute(
        path: '/about',
        name: 'about',
        builder: (context, state) => const InfoPage(kind: InfoKind.about),
      ),
    ],
  );
});
