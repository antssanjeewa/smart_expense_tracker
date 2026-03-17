import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_expense_tracker/features/auth/domain/usecases/biometric_login_use_case.dart';
import '../../../core/services/biometric_auth_service.dart';
import '../data/provider.dart';
import 'usecases/login_usecase.dart';
import 'usecases/logout_usecase.dart';

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return LoginUseCase(repo);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repo);
});

final biometricLoginUseCaseProvider = Provider<BiometricLoginUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  final biometricService = BiometricAuthService();
  return BiometricLoginUseCase(repo, biometricService);
});

final authStateProvider = StreamProvider<String?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});
