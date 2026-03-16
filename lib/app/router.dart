import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_shell.dart';
import 'pages.dart';

import '../features/not_found_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/splash/presentation/splash_page.dart';
import '../features/dashboard/presentation/pages/home_page.dart';

final GoRouter router = GoRouter(
  initialLocation: Pages.splash.toPath(),
  routes: [
    GoRoute(
      path: Pages.splash.toPath(),
      name: Pages.splash.toPathName(),
      builder: (context, state) => SplashPage(),
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
          builder: (context, state) => HomePage(),
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
);
