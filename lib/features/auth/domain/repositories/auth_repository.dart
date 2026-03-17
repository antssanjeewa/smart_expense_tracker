abstract class AuthRepository {
  Future<String?> signIn(String email, String password);
  Future<String?> signInWithToken(String token);

  Future<void> signOut();

  Stream<String?> get authStateChanges;
  Future<String?> getSavedToken();
}
