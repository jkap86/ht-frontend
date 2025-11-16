// lib/features/auth/application/auth_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/repositories/auth_repository_interface.dart';
import '../data/auth_repository.dart';
import 'auth_state.dart';

/// Notifier that coordinates auth operations using clean architecture
class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthRepository _repo;

  // Static cache to preserve state across hot reloads (development only)
  static AuthState? _cachedState;

  AuthNotifier(this._repo) : super(_cachedState ?? const AuthState.initial()) {
    print('🔍 [AuthNotifier] Constructor called, initial state: ${state.status}');
    if (_cachedState != null) {
      print('🔍 [AuthNotifier] Restored state from cache: ${_cachedState!.status}, user: ${_cachedState!.user?.username}');
    }
  }

  void _setState(AuthState newState) {
    print('🔍 [AuthNotifier] State change: ${state.status} -> ${newState.status}, user: ${newState.user?.username}');
    state = newState;
    // Cache the state for hot reload persistence
    _cachedState = newState;
    print('🔍 [AuthNotifier] State cached for hot reload');
  }

  Future<void> register(String username, String password) async {
    _setState(state.copyWith(isLoading: true, clearError: true));

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

  Future<void> login(String username, String password) async {
    _setState(state.copyWith(isLoading: true, clearError: true));

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

  /// Check auth on app start: read token, fetch user info, update state
  Future<void> checkAuth() async {
    _setState(state.copyWith(isLoading: true, clearError: true));

    try {
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
      // Try to refresh the token before logging out
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
        // If refresh also fails, clear token and mark unauthenticated
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

  /// Backwards-compatible alias for checkAuth
  Future<void> restoreSession() async {
    await checkAuth();
  }

  Future<void> logout() async {
    await _repo.logout();
    _setState(
      const AuthState(
        status: AuthStatus.unauthenticated,
        user: null,
        isLoading: false,
        error: null,
      ),
    );
  }
}

/// Provider for auth repository using interface
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepository();
});

/// Global provider for [AuthNotifier] and [AuthState]
/// Now using clean architecture with repository interface
/// Note: keepAlive prevents provider from being disposed on hot reload
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) {
    print('🔍 [authProvider] Provider creation/rebuild called');
    // Keep this provider alive to maintain auth state across hot reloads
    ref.keepAlive();
    print('🔍 [authProvider] keepAlive called');
    final repo = ref.watch(authRepositoryProvider);
    final notifier = AuthNotifier(repo);
    print('🔍 [authProvider] Created new AuthNotifier instance');
    return notifier;
  },
);
