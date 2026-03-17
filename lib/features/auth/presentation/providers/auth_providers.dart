import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_controller.dart';

final authControllerProvider = AsyncNotifierProvider<AuthController, String?>(
  () {
    return AuthController();
  },
);

final passwordVisibilityProvider = NotifierProvider<PasswordVisibility, bool>(
  isAutoDispose: true,
  () {
    return PasswordVisibility();
  },
);
