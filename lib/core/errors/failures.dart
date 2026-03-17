abstract class Failure {
  final String message;

  Failure(this.message);
}

class NetworkFailure extends Failure {
  NetworkFailure(super.message);
}

class AuthenticationFailure extends Failure {
  AuthenticationFailure(super.message);
}

class ValidationFailure extends Failure {
  ValidationFailure(super.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}
