// lib/core/infrastructure/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

/// A lightweight API client that knows how to:
/// - Build full URLs from a baseUrl + path
/// - Attach Authorization: Bearer <token> if provided
/// - Handle basic JSON encoding/decoding
///
/// This is intentionally minimal and can be extended as your app grows.
class ApiClient {
  final String baseUrl;
  final http.Client _client;

  ApiClient({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  Uri _buildUri(String path, [Map<String, dynamic>? queryParameters]) {
    final uri = Uri.parse(baseUrl);
    return uri.replace(
      path: _joinPaths(uri.path, path),
      queryParameters: queryParameters?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }

  String _joinPaths(String basePath, String relativePath) {
    final a = basePath.endsWith('/')
        ? basePath.substring(0, basePath.length - 1)
        : basePath;
    final b =
        relativePath.startsWith('/') ? relativePath.substring(1) : relativePath;
    return '$a/$b';
  }

  Map<String, String> _buildHeaders(
      {String? token, Map<String, String>? extraHeaders}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }

    return headers;
  }

  Future<http.Response> postJson(
    String path, {
    required Map<String, dynamic> body,
    String? token,
    Map<String, String>? extraHeaders,
  }) async {
    final uri = _buildUri(path);
    final headers = _buildHeaders(token: token, extraHeaders: extraHeaders);
    final jsonBody = jsonEncode(body);

    return _client.post(uri, headers: headers, body: jsonBody);
  }

  Future<http.Response> getJson(
    String path, {
    String? token,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? extraHeaders,
  }) async {
    final uri = _buildUri(path, queryParameters);
    final headers = _buildHeaders(token: token, extraHeaders: extraHeaders);

    return _client.get(uri, headers: headers);
  }

  // You can add put/patch/delete later as needed.
}
