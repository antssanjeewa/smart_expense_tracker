import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/more/presentation/providers/settings_di.dart';
import 'router.dart';
import 'theme/theme.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final settings = ref.watch(appSettingsProvider);

    return MaterialApp.router(
      title: 'Smart Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
      builder: (context, child) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: child,
      ),
    );
  }
}
