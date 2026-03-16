import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'app_text_theme.dart';

final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

ThemeData lightTheme() {
  return ThemeData(
    useMaterial3: true,
    primaryColor: Color(0xFF2BB673),
    scaffoldBackgroundColor: Color(0xFFF7F9FC),
  );
}

ThemeData darkTheme() {
  return ThemeData(
    useMaterial3: true,

    brightness: Brightness.dark,

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2BB673),
      brightness: Brightness.dark,
    ),

    scaffoldBackgroundColor: const Color(0xFF121212),
    textTheme: AppTextTheme.getDarkTextTheme(),

    appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
  );
}
