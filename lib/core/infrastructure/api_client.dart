// lib/core/infrastructure/api_client.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_exceptions.dart';

/// A lightweight API client that knows how to:
/// - Build full URLs from a baseUrl + path
/// - Attach Authorization: Bearer <token> if provided
/// - Handle basic JSON encoding/decoding
/// - Parse responses and throw typed exceptions
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

  /// Handles HTTP errors and throws appropriate exceptions
  void _handleError(http.Response response) {
    final statusCode = response.statusCode;
    dynamic responseBody;

    // Try to parse response body as JSON
    try {
      responseBody = jsonDecode(response.body);
    } catch (_) {
      // If not JSON, use raw body
      responseBody = response.body;
    }

    // Extract error message if available
    String message;
    if (responseBody is Map<String, dynamic>) {
      message = responseBody['message'] as String? ??
          responseBody['error'] as String? ??
          'Request failed with status $statusCode';
    } else {
      message = 'Request failed with status $statusCode';
    }

    switch (statusCode) {
      case 400:
        // Check if it's a validation error
        if (responseBody is Map<String, dynamic> &&
            responseBody.containsKey('errors')) {
          throw ValidationException(
            message: message,
            validationErrors: responseBody['errors'] as Map<String, dynamic>?,
            responseBody: responseBody,
          );
        }
        throw ValidationException(
          message: message,
          responseBody: responseBody,
        );
      case 401:
        throw UnauthorizedException(
          message: message,
          responseBody: responseBody,
        );
      case 403:
        throw ForbiddenException(
          message: message,
          responseBody: responseBody,
        );
      case 404:
        throw NotFoundException(
          message: message,
          responseBody: responseBody,
        );
      case >= 500:
        throw ServerException(
          message: message,
          statusCode: statusCode,
          responseBody: responseBody,
        );
      default:
        throw UnknownApiException(
          message: message,
          statusCode: statusCode,
          responseBody: responseBody,
        );
    }
  }

  /// Wraps HTTP calls with error handling
  Future<http.Response> _executeRequest(
    Future<http.Response> Function() request,
  ) async {
    try {
      final response = await request();

      // Check if response indicates an error
      if (response.statusCode >= 400) {
        _handleError(response);
      }

      return response;
    } on SocketException catch (e) {
      throw NetworkException(
        message: 'Network error: ${e.message}',
      );
    } on TimeoutException catch (_) {
      throw const TimeoutException();
    } on ApiException {
      // Re-throw API exceptions as-is
      rethrow;
    } catch (e) {
      // Wrap any other errors
      throw UnknownApiException(
        message: 'Unexpected error: $e',
      );
    }
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

    return _executeRequest(
      () => _client.post(uri, headers: headers, body: jsonBody),
    );
  }

  Future<http.Response> getJson(
    String path, {
    String? token,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? extraHeaders,
  }) async {
    final uri = _buildUri(path, queryParameters);
    final headers = _buildHeaders(token: token, extraHeaders: extraHeaders);

    return _executeRequest(
      () => _client.get(uri, headers: headers),
    );
  }

  Future<http.Response> putJson(
    String path, {
    required Map<String, dynamic> body,
    String? token,
    Map<String, String>? extraHeaders,
  }) async {
    final uri = _buildUri(path);
    final headers = _buildHeaders(token: token, extraHeaders: extraHeaders);
    final jsonBody = jsonEncode(body);

    return _executeRequest(
      () => _client.put(uri, headers: headers, body: jsonBody),
    );
  }

  Future<http.Response> patchJson(
    String path, {
    required Map<String, dynamic> body,
    String? token,
    Map<String, String>? extraHeaders,
  }) async {
    final uri = _buildUri(path);
    final headers = _buildHeaders(token: token, extraHeaders: extraHeaders);
    final jsonBody = jsonEncode(body);

    return _executeRequest(
      () => _client.patch(uri, headers: headers, body: jsonBody),
    );
  }

  Future<http.Response> deleteJson(
    String path, {
    String? token,
    Map<String, String>? extraHeaders,
  }) async {
    final uri = _buildUri(path);
    final headers = _buildHeaders(token: token, extraHeaders: extraHeaders);

    return _executeRequest(
      () => _client.delete(uri, headers: headers),
    );
  }
}
