// lib/features/auth/application/auth_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/repositories/auth_repository_interface.dart';
import '../data/auth_repository_new.dart';
import 'auth_state.dart';

/// Notifier that coordinates auth operations using clean architecture
class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthRepository _repo;

  AuthNotifier(this._repo) : super(const AuthState.initial());

  void _setState(AuthState newState) {
    state = newState;
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
      // If getCurrentUser fails, clear token and mark unauthenticated
      await _repo.logout();
      _setState(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          clearUser: true,
          isLoading: false,
          error: e.toString(),
        ),
      );
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
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});
