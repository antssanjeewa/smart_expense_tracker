import '../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<void> call(String email, String password) async {
    return await _repository.signOut();
  }
}
