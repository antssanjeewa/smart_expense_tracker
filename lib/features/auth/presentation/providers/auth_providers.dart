import 'package:flutter_riverpod/legacy.dart';
import 'auth_controller.dart';
import 'auth_state.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController();
  },
);
