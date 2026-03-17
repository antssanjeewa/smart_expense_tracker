import 'package:smart_expense_tracker/core/services/logger_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../domain/repositories/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  final sb.SupabaseClient _client;
  final SecureStorageService _storage;

  final logger = LoggerService();

  SupabaseAuthRepository(this._client, this._storage);

  @override
  Future<String?> signIn(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final refreshToken = response.session?.refreshToken;
      if (refreshToken != null) {
        await _storage.write('refresh_token', refreshToken);
      }

      logger.i("User logged in successfully: ${response.user?.id}");
      return response.user?.id;
    } catch (e, stackTrace) {
      logger.e("Login process failed", e, stackTrace);
      throw AppException.fromError(e);
    }
  }

  @override
  Future<String?> signInWithToken(String token) async {
    try {
      final response = await _client.auth.setSession(token);

      final String? newToken = response.session?.refreshToken;
      if (newToken != null) {
        await _storage.write('refresh_token', newToken);
      }

      logger.i("User logged in with token successfully: ${response.user?.id}");
      return response.user?.id;
    } catch (e) {
      logger.e("Login process failed", e);
      throw AppException.fromError(e);
    }
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  @override
  Stream<String?> get authStateChanges =>
      _client.auth.onAuthStateChange.map((event) => event.session?.user.id);

  @override
  Future<String?> getSavedToken() async {
    final token = await _storage.read('refresh_token');

    if (token == null) {
      logger.w("No saved token found in secure storage.");
      throw AppException('No saved session. Please login with password.');
    }

    return token;
  }
}
