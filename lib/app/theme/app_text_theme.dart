import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';

class AppTextTheme {
  static TextTheme getDarkTextTheme() {
    return const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.onSurface,
      ),

      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 1,
      ),

      bodyLarge: TextStyle(fontSize: 16, letterSpacing: 1),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: AppColors.onSurface,
        letterSpacing: 0.5,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: AppColors.onSurface,
        letterSpacing: 0.5,
      ),

      labelLarge: TextStyle(fontSize: 14, color: AppColors.onBackground),
      labelMedium: TextStyle(fontSize: 12, color: AppColors.onBackground),
      labelSmall: TextStyle(fontSize: 10, color: AppColors.onBackground),
    );
  }
}
