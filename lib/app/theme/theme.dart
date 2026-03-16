import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:smart_expense_tracker/app/theme/app_input_decoration_theme.dart';

import '../../core/constants/app_colors.dart';
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
      seedColor: AppColors.secondary,
      brightness: Brightness.dark,
    ),

    scaffoldBackgroundColor: AppColors.background,
    textTheme: AppTextTheme.getDarkTextTheme(),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),

    inputDecorationTheme: AppInputDecorationTheme.darkInputDecorationTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
