import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/application/auth_notifier.dart';
import '../../../config/app_config_provider.dart';
import 'socket_service.dart';

/// Global socket service provider
/// This is shared across all features that need WebSocket connectivity
///
/// Note: Uses AuthTokenProvider for token access, maintaining proper
/// separation - SocketService only gets token reading capability.
final socketServiceProvider = Provider<SocketService>((ref) {
  final tokenProvider = ref.watch(authTokenProvider);
  final config = ref.watch(appConfigProvider);
  final service = SocketService(
    tokenProvider: tokenProvider,
    baseUrl: config.apiBaseUrl,
  );
  ref.keepAlive();
  return service;
});
