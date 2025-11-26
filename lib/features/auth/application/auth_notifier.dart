// lib/features/auth/application/auth_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/app_config_provider.dart';
import '../../../core/infrastructure/api_client.dart';
import '../domain/repositories/auth_repository_interface.dart';
import '../data/auth_repository.dart';
import '../data/auth_api_client.dart';
import '../data/auth_storage.dart';
import 'auth_state.dart';

/// Notifier that coordinates auth operations using clean architecture
class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthRepository _repo;

  // Static cache to preserve state across hot reloads
  static AuthState? _cachedState;
  static bool _isRestoring = false;

  AuthNotifier(this._repo) : super(_cachedState ?? const AuthState.initial()) {
    // Only restore from storage if:
    // 1. No cached state exists (first run), OR
    // 2. Cached state is unknown (initial/restoring), OR
    // 3. Cached state is unauthenticated (logged out or failed restore)
    // AND we're not already in the middle of a restore operation
    final shouldRestore = _cachedState == null ||
        _cachedState!.status == AuthStatus.unknown ||
        _cachedState!.status == AuthStatus.unauthenticated;

    if (shouldRestore && !_isRestoring) {
      _restoreOnStart();
    }
  }

  Future<void> _restoreOnStart() async {
    // Prevent multiple simultaneous restore attempts
    if (_isRestoring) {
      return;
    }

    _isRestoring = true;

    try {
      await restoreSession();
    } finally {
      _isRestoring = false;
    }
  }

  void _setState(AuthState newState) {
    state = newState;
    _cachedState = newState;
  }

  /// Register a new user and log them in
  Future<void> register(String username, String password) async {
    _setState(
      state.copyWith(
        isLoading: true,
        clearError: true,
      ),
    );

    try {
      final authResult = await _repo.register(username.trim(), password);

      _setState(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: authResult.user,
          isLoading: false,
          clearError: true,
        ),
      );
    } catch (e) {
      _setState(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          isLoading: false,
          error: e.toString(),
        ),
      );
    }
  }

  /// Login with username + password
  Future<void> login(String username, String password) async {
    _setState(
      state.copyWith(
        isLoading: true,
        clearError: true,
      ),
    );

    try {
      final authResult = await _repo.login(username.trim(), password);

      _setState(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: authResult.user,
          isLoading: false,
          clearError: true,
        ),
      );
    } catch (e) {
      _setState(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          isLoading: false,
          error: e.toString(),
        ),
      );
    }
  }

  /// Logout and clear all auth state
  Future<void> logout() async {
    await _repo.logout();

    // Create the unauthenticated state
    final loggedOutState = state.copyWith(
      status: AuthStatus.unauthenticated,
      clearUser: true,
      isLoading: false,
      clearError: true,
    );

    // Set both state and cache to unauthenticated
    // This ensures consistent state management
    state = loggedOutState;
    _cachedState = loggedOutState;
  }

  /// Restore session from stored tokens:
  /// 1. Try /me with current access token
  /// 2. If that fails, try refreshAccessToken()
  /// 3. If that also fails, clear tokens and mark unauthenticated
  Future<void> restoreSession() async {
    _setState(
      state.copyWith(
        isLoading: true,
        clearError: true,
      ),
    );

    try {
      // Try to fetch current user with existing access token
      final user = await _repo.getCurrentUser();

      _setState(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          isLoading: false,
          clearError: true,
        ),
      );
    } catch (e) {
      // If /me fails, try refreshing the access token
      try {
        final authResult = await _repo.refreshAccessToken();

        _setState(
          state.copyWith(
            status: AuthStatus.authenticated,
            user: authResult.user,
            isLoading: false,
            clearError: true,
          ),
        );
      } catch (refreshError) {
        await _repo.logout();
        _setState(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            clearUser: true,
            isLoading: false,
            error: refreshError.toString(),
          ),
        );
      }
    }
  }
}

/// Shared preferences provider
/// Must be overridden in main() with actual SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in main()');
});

/// Auth storage provider
final authStorageProvider = Provider<AuthStorage>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthStorage(preferences: prefs);
});

/// Repository provider – exposes the concrete implementation
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  final storage = ref.watch(authStorageProvider);

  final apiClient = ApiClient(baseUrl: config.apiBaseUrl);
  final authApiClient = AuthApiClient(apiClient: apiClient, storage: storage);

  return AuthRepository(apiClient: authApiClient, storage: storage);
});

/// Global auth provider
/// keepAlive prevents the provider from being disposed in normal app usage.
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) {
    ref.keepAlive();
    final repo = ref.watch(authRepositoryProvider);
    final notifier = AuthNotifier(repo);
    return notifier;
  },
);
