import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../../core/infrastructure/api_client.dart';
import '../domain/auth_exceptions.dart';
import 'dtos/auth_result_dto.dart';
import 'dtos/user_dto.dart';
import 'auth_storage.dart';

/// API client for authentication endpoints
/// Handles HTTP communication and returns DTOs
class AuthApiClient {
  final ApiClient _apiClient;
  final AuthStorage _storage;

  AuthApiClient({
    required ApiClient apiClient,
    required AuthStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

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
      final response = await _apiClient.postJson(
        '/api/auth/register',
        body: {'username': username, 'password': password},
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
      final response = await _apiClient.postJson(
        '/api/auth/login',
        body: {'username': username, 'password': password},
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

      final response = await _apiClient.getJson(
        '/api/auth/me',
        token: token,
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        _handleError(response, 'User info retrieval');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      // Backend returns { user: { id, username } }, extract the user object
      final userData = json['user'] as Map<String, dynamic>?;
      if (userData == null) {
        throw const UnauthenticatedException('Invalid response format from /me endpoint');
      }

      return UserDto.fromJson(userData);
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

      final response = await _apiClient.postJson(
        '/api/auth/refresh',
        body: {'refreshToken': refreshToken},
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

  /// Search for users by username
  Future<List<UserDto>> searchUsers(String query) async {
    try {
      final token = await _storage.readToken();
      if (token == null) {
        throw const UnauthenticatedException('No authentication token found');
      }

      final response = await _apiClient.getJson(
        '/api/auth/users/search',
        token: token,
        queryParameters: {'q': query},
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        _handleError(response, 'User search');
      }

      final json = jsonDecode(response.body) as List<dynamic>;
      return json.map((userData) => UserDto.fromJson(userData as Map<String, dynamic>)).toList();
    } catch (e) {
      if (e is AuthException) rethrow;
      _handleNetworkError(e, 'User search');
    }
  }
}
