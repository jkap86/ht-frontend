import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/socket/socket_providers.dart';
import '../../chat/application/chat_providers.dart';

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

/// Adapter provider that wraps the unified ChatNotifier for direct messages
/// This maintains backward compatibility with the DmChatState interface
/// while using the unified chat system underneath.
///
/// Usage: ref.watch(unifiedDmChatProvider(UnifiedDmChatProviderArgs(...)))
final unifiedDmChatProvider = StateNotifierProvider.family<ChatNotifier, ChatState, UnifiedDmChatProviderArgs>(
  (ref, args) {
    final socketService = ref.read(socketServiceProvider);

    final notifier = ChatNotifier(
      socketService: socketService,
      roomName: 'dm_${args.conversationId}',
      incomingEvent: 'dm_message',
      outgoingEvent: 'send_dm',
    );

    ref.onDispose(() {
      notifier.dispose();
    });

    return notifier;
  },
);
