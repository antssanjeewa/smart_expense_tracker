import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';

class AppTextTheme {
  static TextTheme getDarkTextTheme() {
    return const TextTheme(
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.onSurface,
      ),

      titleMedium: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),

      bodyLarge: TextStyle(
        fontSize: 16,
        color: AppColors.onSurface,
        letterSpacing: 0.5,
      ),
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
