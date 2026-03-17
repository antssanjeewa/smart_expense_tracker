import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/provider.dart';
import 'biometric_auth.dart';

class AuthController extends AsyncNotifier<String?> {
  @override
  FutureOr<String?> build() => null;

  final BiometricAuth _biometricAuth = BiometricAuth();

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    final loginUseCase = ref.read(loginUseCaseProvider);

    state = await AsyncValue.guard(() async {
      final userId = await loginUseCase(email, password);

      if (userId == null) {
        throw Exception("Invalid credentials");
      }

      return userId;
    });
  }

  Future<void> loginWithBiometrics() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final canAuth = await _biometricAuth.canCheckBiometrics();

      if (!canAuth) {
        throw Exception('Biometric authentication not available');
      }

      final success = await _biometricAuth.authenticate();

      if (success) {
        return "biometric_user_id";
      } else {
        throw Exception('Biometric authentication failed');
      }
    });
  }
}

class PasswordVisibility extends Notifier<bool> {
  @override
  bool build() => true;

  void toggle() => state = !state;
}
