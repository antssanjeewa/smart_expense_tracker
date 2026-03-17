import 'dart:io';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});

  @override
  String toString() => message;

  factory AppException.fromError(dynamic error) {
    // 1. Handle Supabase Auth Errors
    if (error is AuthException) {
      return _handleAuthError(error);
    }

    // 2. Handle Database/Postgrest Errors
    if (error is PostgrestException) {
      return AppException(
        'Database error occurred while processing your request.',
        code: error.code,
      );
    }

    // 3. Handle Connectivity Errors
    if (error is SocketException) {
      return AppException('No internet connection. Please check your network.');
    }

    // 4. Handle Platform/Biometric Errors
    if (error is PlatformException) {
      return _handlePlatformError(error);
    }

    if (error.toString().contains('timeout')) {
      return AppException(
        'The server is taking too long to respond. Please try again.',
      );
    }

    // 4. Default Fallback
    return AppException(
      'An unexpected error occurred. Please try again later.',
    );
  }

  static AppException _handleAuthError(AuthException error) {
    final msg = error.message.toLowerCase();

    if (msg.contains('invalid login credentials')) {
      return AppException('Invalid email or password.');
    } else if (msg.contains('email not confirmed')) {
      return AppException(
        'Please verify your email address before logging in.',
      );
    } else if (msg.contains('too many requests')) {
      return AppException(
        'Too many attempts. Please try again after some time.',
      );
    } else if (msg.contains('user not found')) {
      return AppException('No account found with this email.');
    }

    return AppException(error.message);
  }

  static AppException _handlePlatformError(PlatformException error) {
    switch (error.code) {
      case 'NotAvailable':
        return AppException('Biometric security is not set up on this device.');
      case 'NotEnrolled':
        return AppException(
          'No biometrics enrolled. Please check your phone settings.',
        );
      case 'LockedOut':
        return AppException(
          'Too many failed attempts. Biometrics are temporarily locked.',
        );
      default:
        return AppException(
          'Biometric authentication failed. Please try again.',
        );
    }
  }
}
