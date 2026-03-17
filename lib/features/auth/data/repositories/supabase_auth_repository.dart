import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../domain/repositories/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  final sb.SupabaseClient _client;
  SupabaseAuthRepository(this._client);

  @override
  Future<String?> signIn(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response.user?.id;
  }

  @override
  Future<void> signOut() => _client.auth.signOut();

  @override
  Stream<String?> get authStateChanges =>
      _client.auth.onAuthStateChange.map((event) => event.session?.user.id);
}
