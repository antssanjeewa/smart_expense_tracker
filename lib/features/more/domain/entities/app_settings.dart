class AppSettings {
  final bool isDarkMode;
  final String currency;
  final bool isBiometricEnabled;

  const AppSettings({
    this.isDarkMode = true,
    this.currency = "LKR",
    this.isBiometricEnabled = false,
  });

  AppSettings copyWith({
    bool? isDarkMode,
    String? currency,
    bool? isBiometricEnabled,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      currency: currency ?? this.currency,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
    );
  }
}
