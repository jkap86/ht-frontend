import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../../main.dart';
import '../domain/auth_exceptions.dart';
import 'dtos/auth_result_dto.dart';
import 'dtos/user_dto.dart';
import 'auth_token_storage.dart';

/// API client for authentication endpoints
/// Handles HTTP communication and returns DTOs
class AuthApiClient {
  final String _baseUrl = appConfig.apiBaseUrl;
  final http.Client _client;
  final AuthTokenStorage _storage;

  AuthApiClient({
    http.Client? client,
    AuthTokenStorage? storage,
  })  : _client = client ?? http.Client(),
        _storage = storage ?? AuthTokenStorage();

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');

  /// Parse HTTP errors and throw appropriate exceptions
  Never _handleError(http.Response response, String operation) {
    final statusCode = response.statusCode;

    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final errorMessage = json['error'] as String? ?? 'Unknown error occurred';

      switch (statusCode) {
        case 400:
          throw ValidationException(errorMessage);
        case 401:
          throw InvalidCredentialsException(errorMessage);
        case 404:
          throw NotFoundException(errorMessage);
        case 409:
          throw ConflictException(errorMessage);
        default:
          throw ServerException(errorMessage, statusCode);
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw ServerException('$operation failed with status $statusCode', statusCode);
    }
  }

  /// Handle network errors
  Never _handleNetworkError(Object error, String operation) {
    if (error is SocketException) {
      throw const NetworkException('Unable to connect to server');
    }
    if (error is FormatException) {
      throw const NetworkException('Invalid response from server');
    }
    throw NetworkException('$operation failed: ${error.toString()}');
  }

  /// Register a new user
  Future<AuthResultDto> register(String username, String password) async {
    try {
      final response = await _client.post(
        _uri('/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        _handleError(response, 'Registration');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return AuthResultDto.fromJson(json);
    } catch (e) {
      if (e is AuthException) rethrow;
      _handleNetworkError(e, 'Registration');
    }
  }

  /// Login with credentials
  Future<AuthResultDto> login(String username, String password) async {
    try {
      final response = await _client.post(
        _uri('/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        _handleError(response, 'Login');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return AuthResultDto.fromJson(json);
    } catch (e) {
      if (e is AuthException) rethrow;
      _handleNetworkError(e, 'Login');
    }
  }

  /// Get current user info
  Future<UserDto> me() async {
    try {
      final token = await _storage.readToken();
      if (token == null) {
        throw const UnauthenticatedException('No authentication token found');
      }

      final response = await _client.get(
        _uri('/api/auth/me'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        _handleError(response, 'User info retrieval');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return UserDto.fromJson(json);
    } catch (e) {
      if (e is AuthException) rethrow;
      _handleNetworkError(e, 'User info retrieval');
    }
  }

  /// Refresh access token
  Future<AuthResultDto> refreshAccessToken() async {
    try {
      final refreshToken = await _storage.readRefreshToken();
      if (refreshToken == null) {
        throw const TokenRefreshException('No refresh token available');
      }

      final response = await _client.post(
        _uri('/api/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        _handleError(response, 'Token refresh');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return AuthResultDto.fromJson(json);
    } catch (e) {
      if (e is AuthException) rethrow;
      _handleNetworkError(e, 'Token refresh');
    }
  }
}
