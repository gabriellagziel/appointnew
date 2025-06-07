import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/auth_wrapper.dart';
import '../features/personal_scheduler/presentation/personal_home_screen.dart';
import '../providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(auth.stream),
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AuthWrapper(),
      ),
      GoRoute(
        path: '/personal/home',
        builder: (context, state) => const PersonalHomeScreen(),
      ),
    ],
    redirect: (context, state) {
      final user = auth.value;
      final loggingIn = state.location == '/';

      if (user == null) {
        return loggingIn ? null : '/';
      }

      if (state.location == '/' || loggingIn) {
        return '/personal/home';
      }
      return null;
    },
  );
});
