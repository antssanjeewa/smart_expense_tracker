import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/domain/provider.dart';
import 'app_shell.dart';
import 'pages.dart';

import '../features/not_found_page.dart';
import '../features/history/presentation/pages/add_transaction.dart';
import '../features/history/presentation/pages/history_page.dart';
import '../features/more/presentation/pages/more_page.dart';
import '../features/stats/presentation/pages/stats_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/splash/presentation/splash_page.dart';
import '../features/dashboard/presentation/pages/home_page.dart';

final splashReadyProvider = FutureProvider<bool>((ref) async {
  await Future.delayed(const Duration(seconds: 3));
  return true;
});

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final splashReady = ref.watch(splashReadyProvider);

  return GoRouter(
    initialLocation: Pages.splash.toPath(),
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: Pages.splash.toPath(),
        name: Pages.splash.toPathName(),
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: Pages.login.toPath(),
        name: Pages.login.toPathName(),
        builder: (context, state) => const LoginPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: Pages.home.toPath(),
            name: Pages.home.toPathName(),
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: Pages.history.toPath(),
            name: Pages.history.toPathName(),
            builder: (context, state) => const HistoryPage(),
            routes: [
              GoRoute(
                path: Pages.addTransaction.toPath(isSubRoute: true),
                name: Pages.addTransaction.toPathName(),
                builder: (context, state) => const AddTransaction(),
              ),
            ],
          ),
          GoRoute(
            path: Pages.stats.toPath(),
            name: Pages.stats.toPathName(),
            builder: (context, state) => const StatsPage(),
          ),
          GoRoute(
            path: Pages.more.toPath(),
            name: Pages.more.toPathName(),
            builder: (context, state) => const MorePage(),
          ),
        ],
      ),
    ],

    errorPageBuilder: (context, state) {
      return CustomTransitionPage(
        key: state.pageKey,
        child: NotFoundScreen(error: state.error),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      );
    },
    redirect: (context, state) {
      final bool isAuth = authState.value != null;

      final String loginPath = Pages.login.toPath();
      final String splashPath = Pages.splash.toPath();
      final String homePath = Pages.home.toPath();

      final isSplash = state.matchedLocation == splashPath;
      final isLogin = state.matchedLocation == loginPath;

      if (splashReady.isLoading) {
        return isSplash ? null : splashPath;
      }

      if (!isAuth) {
        return isLogin ? null : loginPath;
      }

      if (isSplash || isLogin) {
        return homePath;
      }

      return null;
    },
  );
});
