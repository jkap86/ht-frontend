import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../../main.dart';
import '../domain/auth_exceptions.dart';
import 'auth_token_storage.dart';

/// AuthRepository handles the direct HTTP calls
/// to your backend's /api/auth endpoints.
class AuthRepository {
  final String _baseUrl = appConfig.apiBaseUrl;
  final http.Client _client;
  final AuthTokenStorage _storage;

  AuthRepository({
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
      // If we can't parse the error, throw a generic server exception
      throw ServerException('$operation failed with status $statusCode', statusCode);
    }
  }

  /// Handle network errors (connection failures, timeouts, etc.)
  Never _handleNetworkError(Object error, String operation) {
    if (error is SocketException) {
      throw const NetworkException('Unable to connect to server');
    }
    if (error is FormatException) {
      throw const NetworkException('Invalid response from server');
    }
    throw NetworkException('$operation failed: ${error.toString()}');
  }

  Future<Map<String, dynamic>> register(String username, String password) async {
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
      final token = json['token'] as String?;
      final refreshToken = json['refreshToken'] as String?;

      if (token != null) {
        await _storage.saveToken(token);
      }
      if (refreshToken != null) {
        await _storage.saveRefreshToken(refreshToken);
      }

      return json;
    } catch (e) {
      if (e is AuthException) rethrow;
      _handleNetworkError(e, 'Registration');
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
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
      final token = json['token'] as String?;
      final refreshToken = json['refreshToken'] as String?;

      if (token != null) {
        await _storage.saveToken(token);
      }
      if (refreshToken != null) {
        await _storage.saveRefreshToken(refreshToken);
      }

      return json;
    } catch (e) {
      if (e is AuthException) rethrow;
      _handleNetworkError(e, 'Login');
    }
  }

  Future<Map<String, dynamic>> me() async {
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

      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      if (e is AuthException) rethrow;
      _handleNetworkError(e, 'User info retrieval');
    }
  }

  Future<Map<String, dynamic>> refreshAccessToken() async {
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
      final newAccessToken = json['token'] as String?;
      final newRefreshToken = json['refreshToken'] as String?;

      if (newAccessToken != null) {
        await _storage.saveToken(newAccessToken);
      }
      if (newRefreshToken != null) {
        await _storage.saveRefreshToken(newRefreshToken);
      }

      return json;
    } catch (e) {
      if (e is AuthException) rethrow;
      _handleNetworkError(e, 'Token refresh');
    }
  }

  Future<void> logout() async {
    await _storage.clearToken();
  }
}
