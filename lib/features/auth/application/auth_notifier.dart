import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_state.dart';
import '../infrastructure/auth_repository.dart';
import '../infrastructure/auth_token_storage.dart';
import '../../../config/app_config.dart';

/// Repository provider so we can inject it into the AuthNotifier.
///
/// Base URL comes from [appConfig.apiBaseUrl], which is populated from
/// the APP_CONFIG dart-define JSON.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final baseUrl = appConfig.apiBaseUrl;

  // Optional: helpful in dev logs
  // ignore: avoid_print
  print('🔧 AuthRepository baseUrl = $baseUrl (env: ${appConfig.env})');

  return AuthRepository(baseUrl: baseUrl);
});

/// Handles authentication logic and exposes [AuthState].
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._authRepository) : super(AuthState.initial());

  final AuthRepository _authRepository;

  /// Attempts to restore a previous session from local storage.
  ///
  /// Call this once near app startup (e.g., from a FutureProvider or
  /// a splash screen) to auto-log the user in if a token is present.
  Future<void> restoreSession() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final stored = await AuthTokenStorage.read();

      if (stored == null) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          username: null,
          token: null,
        );
        return;
      }

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        username: stored.username,
        token: stored.token,
      );
    } catch (e) {
      // If anything goes wrong, just treat as logged out
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        username: null,
        token: null,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Calls the backend to log in with username/password.
  Future<void> login({
    required String username,
    required String password,
  }) async {
    if (username.trim().isEmpty || password.isEmpty) return;

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try {
      final result = await _authRepository.login(
        username: username,
        password: password,
      );

      // Save token + username locally if token is present
      if (result.token != null && result.token!.isNotEmpty) {
        await AuthTokenStorage.save(
          token: result.token!,
          username: result.username,
        );
      }

      state = state.copyWith(
        isAuthenticated: true,
        username: result.username,
        token: result.token,
        isLoading: false,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Logout resets auth state and clears stored token.
  Future<void> logout() async {
    await AuthTokenStorage.clear();

    state = AuthState.initial();
  }
}

/// Global provider for the [AuthNotifier] / [AuthState].
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});
