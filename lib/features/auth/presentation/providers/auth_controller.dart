import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/provider.dart';

class AuthController extends AsyncNotifier<String?> {
  @override
  FutureOr<String?> build() => null;

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    final loginUseCase = ref.read(loginUseCaseProvider);

    state = await AsyncValue.guard(() async {
      final userId = await loginUseCase(email, password);

      return userId;
    });
  }

  Future<void> loginWithBiometrics() async {
    state = const AsyncLoading();
    final biometricLoginUseCase = ref.read(biometricLoginUseCaseProvider);

    state = await AsyncValue.guard(() async {
      final userId = await biometricLoginUseCase();

      return userId;
    });
  }
}

class PasswordVisibility extends Notifier<bool> {
  @override
  bool build() => true;

  void toggle() => state = !state;
}
