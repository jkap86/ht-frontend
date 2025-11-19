import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/app_config_provider.dart';
import '../../../core/chat/base_chat_notifier.dart';
import '../../../core/chat/chat_state.dart';
import '../../../core/infrastructure/api_client.dart';
import '../../../core/services/socket/socket_providers.dart';
import '../../../core/services/socket/socket_service.dart';
import '../../auth/application/auth_notifier.dart';
import '../data/dm_api_client.dart';
import '../data/dm_chat_repository.dart';

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

/// DM-specific chat notifier built on top of [BaseChatNotifier].
///
/// Responsibilities:
/// - Load initial DM conversation messages
/// - Join the DM socket room
/// - Stream new messages in real time
class UnifiedDmChatNotifier extends BaseChatNotifier {
  final String conversationId;
  final String otherUserId;
  final String currentUserId;

  UnifiedDmChatNotifier({
    required SocketService socketService,
    required DmChatRepository repository,
    required this.conversationId,
    required this.otherUserId,
    required this.currentUserId,
  }) : super(
          socketService: socketService,
          repository: repository,
        ) {
    initialize();
  }

  @override
  void onMessageReceived(Map<String, dynamic> message) {
    // If you want to tag messages as "mine" vs "theirs" you can
    // inspect [currentUserId] and message payload here.
    //
    // For now, just use the default behavior.
    super.onMessageReceived(message);
  }
}

/// Adapter provider that wires everything up for a DM conversation.
///
/// Usage:
///   ref.watch(
///     unifiedDmChatProvider(
///       const UnifiedDmChatProviderArgs(
///         conversationId: 'conv_123',
///         otherUserId: 'user_456',
///       ),
///     ),
///   );
final unifiedDmChatProvider = StateNotifierProvider.family<
    UnifiedDmChatNotifier, ChatState, UnifiedDmChatProviderArgs>(
  (ref, args) {
    final config = ref.watch(appConfigProvider);
    final socketService = ref.read(socketServiceProvider);

    // SharedPreferences + Auth wiring
    final sharedPreferences = ref.read(sharedPreferencesProvider);
    final authStorage = ref.read(authStorageProvider);
    final authState = ref.read(authProvider);
    final currentUserId = authState.user?.userId ?? '';

    // Avoid "unused" hints for now – hook these up later if needed.
    final _ = sharedPreferences;

    final apiClient = ApiClient(
      baseUrl: config.apiBaseUrl,
    );

    final dmApiClient = DmApiClient(
      apiClient: apiClient,
      storage: authStorage,
    );

    final repository = DmChatRepository(
      apiClient: dmApiClient,
      conversationId: args.conversationId,
      otherUserId: args.otherUserId,
    );

    final notifier = UnifiedDmChatNotifier(
      socketService: socketService,
      repository: repository,
      conversationId: args.conversationId,
      otherUserId: args.otherUserId,
      currentUserId: currentUserId,
    );

    ref.onDispose(notifier.dispose);

    return notifier;
  },
);
