// lib/features/auth/data/auth_token_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Handles secure storage of authentication tokens (JWT, refresh tokens, etc.)
/// Uses flutter_secure_storage for encrypted storage of sensitive data.
class AuthTokenStorage {
  static const _key = 'auth_token';
  final FlutterSecureStorage _storage;

  AuthTokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: _key, value: token);
  }

  Future<String?> readToken() async {
    return _storage.read(key: _key);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _key);
  }
}
