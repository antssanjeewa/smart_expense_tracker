import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});

  @override
  String toString() =>
      'AppException: $message${code != null ? ' (Code: $code)' : ''}';

  factory AppException.fromError(dynamic error) {
    // 2. Handle Database/Postgrest Errors
    if (error is PostgrestException) {
      return AppException('Database error: ${error.message}');
    }

    // 3. Handle Connectivity Errors
    if (error is SocketException) {
      return AppException('No internet connection. Please check your network.');
    }

    if (error.toString().contains('timeout')) {
      return AppException('The server took too long to respond.');
    }

    // 4. Default Fallback
    return AppException('An unexpected error occurred. Please try again.');
  }
}
