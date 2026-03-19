import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/app_settings.dart';

class SettingsController {
  static const _darkModeKey = 'is_dark_mode';
  static const _currencyKey = 'selected_currency';
  static const _biometricKey = 'is_biometric_enabled';

  Future<void> saveSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, settings.isDarkMode);
    await prefs.setString(_currencyKey, settings.currency);
    await prefs.setBool(_biometricKey, settings.isBiometricEnabled);
  }

  Future<AppSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return AppSettings(
      isDarkMode: prefs.getBool(_darkModeKey) ?? true,
      currency: prefs.getString(_currencyKey) ?? "LKR",
      isBiometricEnabled: prefs.getBool(_biometricKey) ?? false,
    );
  }
}
