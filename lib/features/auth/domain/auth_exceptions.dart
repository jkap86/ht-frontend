// lib/features/auth/domain/auth_exceptions.dart

/// Base class for all authentication-related exceptions
abstract class AuthException implements Exception {
  final String message;
  final int? statusCode;

  const AuthException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

/// Thrown when user credentials are invalid
class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException([String? message])
      : super(message ?? 'Invalid username or password', 401);
}

/// Thrown when a network request fails
class NetworkException extends AuthException {
  const NetworkException([String? message])
      : super(message ?? 'Network error occurred');
}

/// Thrown when the server returns an error
class ServerException extends AuthException {
  const ServerException(String message, [int? statusCode])
      : super(message, statusCode);
}

/// Thrown when input validation fails
class ValidationException extends AuthException {
  const ValidationException(String message) : super(message, 400);
}

/// Thrown when a resource is not found
class NotFoundException extends AuthException {
  const NotFoundException([String? message])
      : super(message ?? 'Resource not found', 404);
}

/// Thrown when there's a conflict (e.g., username already exists)
class ConflictException extends AuthException {
  const ConflictException(String message) : super(message, 409);
}

/// Thrown when token refresh fails
class TokenRefreshException extends AuthException {
  const TokenRefreshException([String? message])
      : super(message ?? 'Failed to refresh authentication token', 401);
}

/// Thrown when user is not authenticated
class UnauthenticatedException extends AuthException {
  const UnauthenticatedException([String? message])
      : super(message ?? 'User is not authenticated', 401);
}
