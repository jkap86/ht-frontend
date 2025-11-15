import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/infrastructure/api_client.dart';

class AuthResult {
  final String id;
  final String username;
  final String? email;
  final String? phoneNumber;
  final String? token;

  const AuthResult({
    required this.id,
    required this.username,
    this.email,
    this.phoneNumber,
    this.token,
  });
}

class AuthRepository {
  final ApiClient _apiClient;

  /// [baseUrl] should be your backend root, e.g.:
  ///   http://localhost:5000
  ///
  /// We’ll internally call `${baseUrl}/api/...`.
  AuthRepository({required String baseUrl})
      : _apiClient = ApiClient(baseUrl: '$baseUrl/api');

  /// POST /api/auth/login
  Future<AuthResult> login({
    required String username,
    required String password,
  }) async {
    final response = await _apiClient.postJson(
      '/auth/login',
      body: {
        'username': username,
        'password': password,
      },
    );

    return _handleAuthResponse(response);
  }

  /// POST /api/auth/register
  ///
  /// You can call this from your RegisterScreen when you’re ready.
  Future<AuthResult> register({
    required String username,
    required String password,
    String? email,
    String? phoneNumber,
  }) async {
    final response = await _apiClient.postJson(
      '/auth/register',
      body: {
        'username': username,
        'password': password,
        if (email != null && email.isNotEmpty) 'email': email,
        if (phoneNumber != null && phoneNumber.isNotEmpty)
          'phoneNumber': phoneNumber,
      },
    );

    return _handleAuthResponse(response);
  }

  AuthResult _handleAuthResponse(http.Response response) {
    final statusCode = response.statusCode;

    Map<String, dynamic> decodeBody() {
      try {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } catch (_) {
        return <String, dynamic>{};
      }
    }

    if (statusCode >= 200 && statusCode < 300) {
      final data = decodeBody();

      return AuthResult(
        id: (data['id'] ?? '') as String,
        username: (data['username'] ?? '') as String,
        email: data['email'] as String?,
        phoneNumber: data['phoneNumber'] as String?,
        token: data['token'] as String?,
      );
    } else {
      final data = decodeBody();
      final message =
          (data['message'] ?? data['error'] ?? 'Unknown error') as String;

      throw Exception('Auth error ($statusCode): $message');
    }
  }
}
