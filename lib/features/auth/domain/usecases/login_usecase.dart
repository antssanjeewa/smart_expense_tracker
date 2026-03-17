import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<String?> call(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception("Email and Password cannot be empty");
    }

    return await _repository.signIn(email, password);
  }
}
