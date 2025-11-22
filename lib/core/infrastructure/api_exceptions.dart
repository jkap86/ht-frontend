// lib/core/infrastructure/api_exceptions.dart

/// Base class for all API exceptions
abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic responseBody;

  const ApiException({
    required this.message,
    this.statusCode,
    this.responseBody,
  });

  @override
  String toString() {
    final buffer = StringBuffer(runtimeType.toString());
    buffer.write(': $message');
    if (statusCode != null) {
      buffer.write(' (Status: $statusCode)');
    }
    return buffer.toString();
  }
}

/// Thrown when there's a network connectivity issue
class NetworkException extends ApiException {
  const NetworkException({
    required super.message,
  }) : super(statusCode: null, responseBody: null);
}

/// Thrown when the user is not authenticated (401)
class UnauthorizedException extends ApiException {
  const UnauthorizedException({
    super.message = 'Unauthorized - Please log in again',
    super.responseBody,
  }) : super(
          statusCode: 401,
        );
}

/// Thrown when the user doesn't have permission (403)
class ForbiddenException extends ApiException {
  const ForbiddenException({
    super.message = 'Forbidden - You do not have permission to access this resource',
    super.responseBody,
  }) : super(
          statusCode: 403,
        );
}

/// Thrown when the requested resource is not found (404)
class NotFoundException extends ApiException {
  const NotFoundException({
    super.message = 'Resource not found',
    super.responseBody,
  }) : super(
          statusCode: 404,
        );
}

/// Thrown when the request has validation errors (400)
class ValidationException extends ApiException {
  final Map<String, dynamic>? validationErrors;

  const ValidationException({
    super.message = 'Validation failed',
    this.validationErrors,
    super.responseBody,
  }) : super(
          statusCode: 400,
        );

  @override
  String toString() {
    final buffer = StringBuffer(super.toString());
    if (validationErrors != null && validationErrors!.isNotEmpty) {
      buffer.write('\nValidation errors: $validationErrors');
    }
    return buffer.toString();
  }
}

/// Thrown when the server returns a 5xx error
class ServerException extends ApiException {
  const ServerException({
    super.message = 'Server error - Please try again later',
    super.statusCode = 500,
    super.responseBody,
  });
}

/// Thrown when request times out
class TimeoutException extends ApiException {
  const TimeoutException({
    super.message = 'Request timeout - Please check your connection',
  }) : super(
          statusCode: null,
          responseBody: null,
        );
}

/// Thrown when we get an unexpected status code
class UnknownApiException extends ApiException {
  const UnknownApiException({
    required super.message,
    super.statusCode,
    super.responseBody,
  });
}
