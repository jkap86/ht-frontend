import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../main.dart';
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

  Future<Map<String, dynamic>> register(String username, String password) async {
    final response = await _client.post(
      _uri('/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
          'Register failed: ${response.statusCode} ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final token = json['token'] as String?;
    if (token != null) {
      await _storage.saveToken(token);
    }

    return json;
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await _client.post(
      _uri('/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Login failed: ${response.statusCode} ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final token = json['token'] as String?;
    if (token != null) {
      await _storage.saveToken(token);
    }

    return json;
  }

  Future<Map<String, dynamic>> me() async {
    final token = await _storage.readToken();
    if (token == null) throw Exception('No stored token');

    final response = await _client.get(
      _uri('/api/auth/me'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Me failed: ${response.statusCode} ${response.body}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<void> logout() async {
    await _storage.clearToken();
  }
}
