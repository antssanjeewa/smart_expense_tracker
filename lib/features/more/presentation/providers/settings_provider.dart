import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/app_settings.dart';
import 'settings_controller.dart';

class AppSettingsNotifier extends Notifier<AppSettings> {
  final _controller = SettingsController();

  @override
  AppSettings build() {
    _init();
    return const AppSettings();
  }

  Future<void> _init() async {
    state = await _controller.loadSettings();
  }

  // Dark Mode toggle කරන්න
  void toggleDarkMode(bool value) {
    state = state.copyWith(isDarkMode: value);
    _controller.saveSettings(state);
  }

  // Currency මාරු කරන්න
  void updateCurrency(String currency) {
    state = state.copyWith(currency: currency);
    _controller.saveSettings(state);
  }

  // Biometric toggle කරන්න
  void toggleBiometric(bool value) {
    state = state.copyWith(isBiometricEnabled: value);
    _controller.saveSettings(state);
  }
}

// Global Provider එක
final appSettingsProvider = NotifierProvider<AppSettingsNotifier, AppSettings>(
  AppSettingsNotifier.new,
);
