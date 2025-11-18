import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/application/auth_notifier.dart';
import '../../../config/app_config.dart';
import 'socket_service.dart';

/// Global socket service provider
/// This is shared across all features that need WebSocket connectivity
final socketServiceProvider = Provider<SocketService>((ref) {
  final storage = ref.watch(authStorageProvider);
  final config = loadAppConfig();
  final service = SocketService(
    storage: storage,
    baseUrl: config.apiBaseUrl,
  );
  ref.keepAlive();
  return service;
});
