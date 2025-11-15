// lib/features/auth/infrastructure/auth_token_storage.dart
import 'package:shared_preferences/shared_preferences.dart';

class StoredAuth {
  final String token;
  final String username;

  const StoredAuth({
    required this.token,
    required this.username,
  });
}

class AuthTokenStorage {
  static const _keyToken = 'auth_token';
  static const _keyUsername = 'auth_username';

  /// Save token + username after successful login/register.
  static Future<void> save({
    required String token,
    required String username,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyUsername, username);
  }

  /// Load token + username on app startup.
  static Future<StoredAuth?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_keyToken);
    final username = prefs.getString(_keyUsername);

    if (token == null ||
        token.isEmpty ||
        username == null ||
        username.isEmpty) {
      return null;
    }

    return StoredAuth(token: token, username: username);
  }

  /// Clear auth info on logout.
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUsername);
  }
}
