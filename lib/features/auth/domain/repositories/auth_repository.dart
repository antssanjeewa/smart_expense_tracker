abstract class AuthRepository {
  Future<String?> signIn(String email, String password);

  Future<void> signOut();

  Stream<String?> get authStateChanges;
}
