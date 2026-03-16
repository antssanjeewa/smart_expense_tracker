import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/errors/exceptions.dart';
import 'auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(const AuthInitial());

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
}
