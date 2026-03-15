import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      // builder: (context, state) => DashboardPage(),
    ),
    GoRoute(
      path: '/transactions',
      // builder: (context, state) => TransactionsPage(),
    ),
    GoRoute(
      path: '/add',
      // builder: (context, state) => AddTransactionPage(),
    ),
  ],
);
