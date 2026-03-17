import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/biometric_auth_service.dart';
import '../repositories/auth_repository.dart';

class BiometricLoginUseCase {
  final AuthRepository _repository;
  final BiometricAuthService _biometricService;

  BiometricLoginUseCase(this._repository, this._biometricService);

  Future<String?> call() async {
    final canAuth = await _biometricService.canCheckBiometrics();

    if (!canAuth) {
      throw AppException(
        'Biometric authentication is not available on this device.',
      );
    }

    final isAuthenticated = await _biometricService.authenticate();

    final token = await _repository.getSavedToken();
    if (token == null) {
      throw AppException('No saved session. Please login with password.');
    }

    if (isAuthenticated) {
      return await _repository.signInWithToken(token);
    } else {
      throw AppException('Biometric authentication failed.');
    }
  }
}
