import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/socket/socket_providers.dart';
import '../../../core/services/socket/socket_service.dart';
import '../../chat/application/chat_providers.dart';
import '../data/dm_api_client.dart';
import '../data/dm_chat_repository.dart';
import '../../../core/infrastructure/api_client.dart';
import '../../auth/data/auth_storage.dart';
import '../../auth/application/auth_notifier.dart';
import '../../../shared/providers/base_chat_notifier.dart';

/// Arguments for [unifiedDmChatProvider].
class UnifiedDmChatProviderArgs {
  final String conversationId;
  final String otherUserId;

  const UnifiedDmChatProviderArgs({
    required this.conversationId,
    required this.otherUserId,
  });

  @override
  bool operator ==(Object other) {
    return other is UnifiedDmChatProviderArgs &&
        other.conversationId == conversationId &&
        other.otherUserId == otherUserId;
  }

  @override
  int get hashCode => Object.hash(conversationId, otherUserId);
}

/// Enhanced ChatNotifier for DM chat that loads initial messages
class DmChatNotifier extends BaseChatNotifier {
  DmChatNotifier({
    required SocketService socketService,
    required String conversationId,
    required String otherUserId,
    required DmApiClient apiClient,
    String? currentUserId, // Not used but kept for API compatibility
  }) : super(
          socketService: socketService,
          repository: DmChatRepository(
            apiClient: apiClient,
            conversationId: conversationId,
            otherUserId: otherUserId,
          ),
        );
}

/// Adapter provider that wraps the unified ChatNotifier for direct messages
/// This maintains backward compatibility with the DmChatState interface
/// while using the unified chat system underneath.
///
/// Usage: ref.watch(unifiedDmChatProvider(UnifiedDmChatProviderArgs(...)))
final unifiedDmChatProvider = StateNotifierProvider.family<DmChatNotifier, ChatState, UnifiedDmChatProviderArgs>(
  (ref, args) {
    final socketService = ref.read(socketServiceProvider);
    final sharedPreferences = ref.read(sharedPreferencesProvider);
    final authState = ref.read(authProvider);

    final currentUserId = authState.user?.userId;
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    // Create API client for loading initial messages
    final apiClient = DmApiClient(
      apiClient: ApiClient(baseUrl: 'http://localhost:5000'),
      storage: AuthStorage(preferences: sharedPreferences),
    );

    final notifier = DmChatNotifier(
      socketService: socketService,
      conversationId: args.conversationId,
      otherUserId: args.otherUserId,
      apiClient: apiClient,
      currentUserId: currentUserId,
    );

    ref.onDispose(() {
      notifier.dispose();
    });

    return notifier;
  },
);
