import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/app_config_provider.dart';
import '../../../features/auth/application/auth_notifier.dart';
import '../../../features/auth/data/auth_token_provider.dart';
import 'socket_service.dart';

/// Global socket service provider
/// This is shared across all features that need WebSocket connectivity
final socketServiceProvider = Provider<SocketService>((ref) {
  final config = ref.watch(appConfigProvider);
  final storage = ref.watch(authStorageProvider);

  final tokenProvider = AuthTokenProvider(storage);

  final service = SocketService(
    tokenProvider: tokenProvider,
    baseUrl: config.apiBaseUrl,
  );

  ref.keepAlive();
  return service;
});
