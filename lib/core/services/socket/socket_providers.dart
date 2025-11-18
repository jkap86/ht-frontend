import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/application/auth_notifier.dart';
import '../../../config/app_config_provider.dart';
import 'socket_service.dart';

/// Global socket service provider
/// This is shared across all features that need WebSocket connectivity
///
/// Note: AuthStorage implements TokenProvider, allowing core to depend on
/// the abstraction rather than the concrete auth implementation.
final socketServiceProvider = Provider<SocketService>((ref) {
  final tokenProvider = ref.watch(authStorageProvider);
  final config = ref.watch(appConfigProvider);
  final service = SocketService(
    tokenProvider: tokenProvider,
    baseUrl: config.apiBaseUrl,
  );
  ref.keepAlive();
  return service;
});
