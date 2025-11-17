import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/socket/socket_providers.dart';
import '../data/chat_repository.dart';
import '../data/chat_socket_client.dart';
import '../../auth/application/auth_notifier.dart';

/// Provider for the shared chat repository
/// Handles both league and DM chat API operations
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final storage = ref.watch(authStorageProvider);
  return ChatRepository(storage: storage);
});

/// Provider for the shared chat socket client
/// Handles both league and DM real-time messaging
final chatSocketClientProvider = Provider<ChatSocketClient>((ref) {
  final socketService = ref.watch(socketServiceProvider);
  return ChatSocketClient(socketService);
});
