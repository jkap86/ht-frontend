// lib/features/auth/application/auth_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/repositories/auth_repository_interface.dart';
import '../data/auth_repository.dart';
import 'auth_state.dart';

/// Notifier that coordinates auth operations using clean architecture
class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthRepository _repo;

  // Static cache to preserve state across hot reloads
  static AuthState? _cachedState;
  static bool _isRestoring = false;

  AuthNotifier(this._repo) : super(_cachedState ?? const AuthState.initial()) {
    // Only restore from storage if we don't have a cached state
    // or if we're in an unauthenticated state
    if (_cachedState == null || _cachedState!.status == AuthStatus.unauthenticated) {
      _restoreOnStart();
    } else if (_cachedState!.status == AuthStatus.unknown) {
      // If we have a cached unknown state, it means we were in the middle of restoring
      // Continue the restoration process
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

    // Clear the cache on explicit logout
    _cachedState = null;

    _setState(
      state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
        isLoading: false,
        clearError: true,
      ),
    );
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

/// Repository provider – exposes the concrete implementation
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepository();
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
