// lib/features/auth/data/auth_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Unified storage for authentication data
/// Uses FlutterSecureStorage for sensitive data (tokens) and SharedPreferences for non-sensitive data
class AuthStorage {
  // Secure storage keys (for sensitive data)
  static const _accessTokenKey = 'auth_token';
  static const _refreshTokenKey = 'refresh_token';

  // Shared preferences keys (for non-sensitive data)
  static const _lastLeagueIdKey = 'last_league_id';

  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _preferences;

  AuthStorage({
    FlutterSecureStorage? secureStorage,
    required SharedPreferences preferences,
  })  : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
        _preferences = preferences;

  // Token operations (secure storage)

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _accessTokenKey, value: token);
  }

  Future<String?> readToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> readRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  Future<void> clearTokens() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
  }

  // Non-sensitive data operations (shared preferences)

  Future<void> saveLastLeagueId(int leagueId) async {
    await _preferences.setInt(_lastLeagueIdKey, leagueId);
  }

  int? getLastLeagueId() {
    return _preferences.getInt(_lastLeagueIdKey);
  }

  Future<void> clearLastLeagueId() async {
    await _preferences.remove(_lastLeagueIdKey);
  }

  // Clear all auth-related data
  Future<void> clearAll() async {
    await clearTokens();
    await clearLastLeagueId();
  }
}
