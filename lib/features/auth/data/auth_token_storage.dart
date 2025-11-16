// lib/features/auth/data/auth_token_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Handles secure storage of authentication tokens (JWT, refresh tokens, etc.)
/// Uses flutter_secure_storage for encrypted storage of sensitive data.
class AuthTokenStorage {
  static const _accessTokenKey = 'auth_token';
  static const _refreshTokenKey = 'refresh_token';
  final FlutterSecureStorage _storage;

  AuthTokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  Future<String?> readToken() async {
    final token = await _storage.read(key: _accessTokenKey);
    return token;
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> readRefreshToken() async {
    final token = await _storage.read(key: _refreshTokenKey);
    return token;
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}
