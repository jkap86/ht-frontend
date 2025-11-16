// lib/features/auth/data/auth_api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../main.dart'; // where appConfig lives

class AuthApiClient {
  final http.Client _client;

  AuthApiClient({http.Client? client}) : _client = client ?? http.Client();

  Uri _uri(String path) {
    // backend endpoints: /api/auth/...
    return Uri.parse('${appConfig.apiBaseUrl}$path');
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      _uri('/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception('Register failed: ${response.statusCode} ${response.body}');
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      _uri('/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception('Login failed: ${response.statusCode} ${response.body}');
  }

  Future<Map<String, dynamic>> me({
    required String token,
  }) async {
    final response = await _client.get(
      _uri('/api/auth/me'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception('Me failed: ${response.statusCode} ${response.body}');
  }
}
