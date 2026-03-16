import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/errors/exceptions.dart';
import 'auth_state.dart';
import 'biometric_auth.dart';

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(const AuthInitial());

  final BiometricAuth _biometricAuth = BiometricAuth();

  Future<void> login(String email, String password) async {
    state = const AuthLoading();

    try {
      final userId = await Future.delayed(const Duration(seconds: 2));
      // final userId = await repository.login(email, password);

      if (userId != null) {
        state = AuthSuccess(userId);
      } else {
        state = const AuthError("Invalid credentials");
      }
    } catch (e) {
      var message = AppException.fromError(e).toString();
      state = AuthError(message);
    }
  }

  Future<void> loginWithBiometrics() async {
    state = const AuthLoading();

    final canAuth = await _biometricAuth.canCheckBiometrics();
    if (!canAuth) {
      state = const AuthError('Biometric authentication not available');
      return;
    }

    try {
      final success = await _biometricAuth.authenticate();
      if (success) {
        state = const AuthSuccess("biometric_user_id");
      } else {
        state = const AuthError('Biometric authentication failed');
      }
    } catch (e) {
      var message = AppException.fromError(e).toString();
      state = AuthError(message);
    }
  }
}
