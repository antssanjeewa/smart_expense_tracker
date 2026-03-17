import 'package:flutter_riverpod/flutter_riverpod.dart';
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

final authStateProvider = StreamProvider<String?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});
