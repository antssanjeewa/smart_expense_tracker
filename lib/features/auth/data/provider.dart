import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/supabase_client.dart';
import '../domain/repositories/auth_repository.dart';
import 'repositories/supabase_auth_repository.dart';

// Provider for Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.read(supabaseClientProvider);
  return SupabaseAuthRepository(client);
});
