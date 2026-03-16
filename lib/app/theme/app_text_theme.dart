import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';

class AppTextTheme {
  static TextTheme getDarkTextTheme() {
    return const TextTheme(
      titleMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),

      bodySmall: TextStyle(
        fontSize: 12,
        color: AppColors.onSurface,
        letterSpacing: 0.5,
      ),

      labelSmall: TextStyle(fontSize: 10, color: AppColors.onSurface),
    );
  }
}
