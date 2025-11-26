// lib/features/auth/data/auth_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/socket/token_provider.dart';

/// Unified storage for authentication data
///
/// Responsibilities:
/// - Store and retrieve JWT access tokens (secure)
/// - Store and retrieve JWT refresh tokens (secure)
/// - Store and retrieve user preferences (non-secure)
/// - Provide atomic clear operations for logout
///
/// Storage Strategy:
/// - Sensitive data (tokens): FlutterSecureStorage (encrypted at rest)
/// - Non-sensitive data (preferences): SharedPreferences (plain text)
///
/// Usage:
/// This class should ONLY be used by AuthRepository.
/// Do NOT call AuthStorage methods directly from UI or business logic.
class AuthStorage implements TokenProvider {
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

  // ========== Token Operations (Secure Storage) ==========

  /// Saves the JWT access token to secure storage
  ///
  /// Used by: AuthRepository after successful login/register/refresh
  /// Storage: FlutterSecureStorage (encrypted)
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _accessTokenKey, value: token);
  }

  /// Reads the JWT access token from secure storage
  ///
  /// Used by: AuthRepository for API requests
  /// Returns: Token string or null if not found
  /// Storage: FlutterSecureStorage (encrypted)
  @override
  Future<String?> readToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  /// Saves the JWT refresh token to secure storage
  ///
  /// Used by: AuthRepository after successful login/register
  /// Storage: FlutterSecureStorage (encrypted)
  Future<void> saveRefreshToken(String refreshToken) async {
    await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
  }

  /// Reads the JWT refresh token from secure storage
  ///
  /// Used by: AuthRepository when access token expires
  /// Returns: Refresh token string or null if not found
  /// Storage: FlutterSecureStorage (encrypted)
  Future<String?> readRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  /// Clears both access and refresh tokens from secure storage
  ///
  /// Used by: AuthRepository during logout or failed refresh
  /// This is an atomic operation that removes both tokens
  Future<void> clearTokens() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
  }

  // ========== Non-Sensitive Data Operations (SharedPreferences) ==========

  /// Saves the last accessed league ID for UX convenience
  ///
  /// Used by: League navigation to remember user's last league
  /// Storage: SharedPreferences (plain text - not sensitive)
  Future<void> saveLastLeagueId(int leagueId) async {
    await _preferences.setInt(_lastLeagueIdKey, leagueId);
  }

  /// Reads the last accessed league ID
  ///
  /// Used by: League navigation to restore user's last league
  /// Returns: League ID or null if not set
  /// Storage: SharedPreferences (plain text - not sensitive)
  int? getLastLeagueId() {
    return _preferences.getInt(_lastLeagueIdKey);
  }

  /// Clears the last accessed league ID
  ///
  /// Used by: Logout flow to reset user preferences
  Future<void> clearLastLeagueId() async {
    await _preferences.remove(_lastLeagueIdKey);
  }

  // ========== Atomic Operations ==========

  /// Clears all auth-related data from both secure and non-secure storage
  ///
  /// Used by: AuthRepository.logout() to completely reset auth state
  /// This is the preferred method for logout as it ensures complete cleanup
  Future<void> clearAll() async {
    await clearTokens();
    await clearLastLeagueId();
  }
}
