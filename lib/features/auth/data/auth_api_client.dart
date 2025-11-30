import 'dart:convert';

import '../../../core/infrastructure/api_client.dart';
import '../../../core/infrastructure/api_exceptions.dart' as api;
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

  /// Convert core API exceptions to auth-specific exceptions
  Never _handleApiException(api.ApiException e, String operation) {
    if (e is api.UnauthorizedException) {
      throw InvalidCredentialsException(e.message);
    } else if (e is api.ValidationException) {
      throw ValidationException(e.message);
    } else if (e is api.NotFoundException) {
      throw NotFoundException(e.message);
    } else if (e is api.NetworkException) {
      throw NetworkException(e.message);
    } else if (e is api.ServerException) {
      throw ServerException(e.message, e.statusCode ?? 500);
    } else {
      throw ServerException(
          '$operation failed: ${e.message}', e.statusCode ?? 500);
    }
  }

  /// Register a new user
  Future<AuthResultDto> register(String username, String password) async {
    try {
      final response = await _apiClient.postJson(
        '/api/auth/register',
        body: {'username': username, 'password': password},
      );

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return AuthResultDto.fromJson(json);
    } on api.ApiException catch (e) {
      _handleApiException(e, 'Registration');
    } on AuthException {
      rethrow;
    }
  }

  /// Login with credentials
  Future<AuthResultDto> login(String username, String password) async {
    try {
      final response = await _apiClient.postJson(
        '/api/auth/login',
        body: {'username': username, 'password': password},
      );

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return AuthResultDto.fromJson(json);
    } on api.ApiException catch (e) {
      _handleApiException(e, 'Login');
    } on AuthException {
      rethrow;
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

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      // Backend returns { user: { id, username } }, extract the user object
      final userData = json['user'] as Map<String, dynamic>?;
      if (userData == null) {
        throw const UnauthenticatedException(
            'Invalid response format from /me endpoint');
      }

      return UserDto.fromJson(userData);
    } on api.ApiException catch (e) {
      _handleApiException(e, 'User info retrieval');
    } on AuthException {
      rethrow;
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

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return AuthResultDto.fromJson(json);
    } on api.ApiException catch (e) {
      _handleApiException(e, 'Token refresh');
    } on AuthException {
      rethrow;
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

      final json = jsonDecode(response.body) as List<dynamic>;
      return json
          .map((userData) => UserDto.fromJson(userData as Map<String, dynamic>))
          .toList();
    } on api.ApiException catch (e) {
      _handleApiException(e, 'User search');
    } on AuthException {
      rethrow;
    }
  }
}
