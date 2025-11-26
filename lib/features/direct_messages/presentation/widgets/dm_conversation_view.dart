import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/unified_dm_chat_provider.dart';
import '../../../chat/presentation/widgets/chat_message_list.dart';
import '../../../chat/presentation/widgets/chat_input_bar.dart';
import '../../../chat/presentation/widgets/chat_error_banner.dart';
import '../../../chat/presentation/widgets/chat_header.dart';
import '../../../auth/application/auth_notifier.dart';

/// Conversation view for a single direct message thread.
///
/// Assumptions:
/// - `conversationId` is the same ID used to join the DM socket room
///   (e.g. sorted `${userId}_${otherUserId}`).
/// - `otherUserId` is the ID of the other participant.
/// - Backend DM payloads have at least a `message` field, optionally
///   `sender_id`, `sender_username`, etc.
class DmConversationView extends ConsumerStatefulWidget {
  final String conversationId;
  final String otherUserId;
  final String? otherUsername;

  const DmConversationView({
    super.key,
    required this.conversationId,
    required this.otherUserId,
    this.otherUsername,
  });

  @override
  ConsumerState<DmConversationView> createState() => _DmConversationViewState();
}

class _DmConversationViewState extends ConsumerState<DmConversationView> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = UnifiedDmChatProviderArgs(
      conversationId: widget.conversationId,
      otherUserId: widget.otherUserId,
    );

    final dmState = ref.watch(unifiedDmChatProvider(args));
    final dmNotifier = ref.read(unifiedDmChatProvider(args).notifier);

    final isLoading = dmState.isConnecting && dmState.messages.isEmpty;
    final currentUserId = ref.read(authProvider).user?.userId;

    // Transform messages to include proper field mappings for ChatMessageList
    final transformedMessages = dmState.messages.map((msg) {
      return {
        'message': msg['message'] ?? '',
        'username': msg['sender_username'] ?? '',
        'user_id': msg['sender_id'],
        'type': 'user', // DM messages are always user type
      };
    }).toList();

    return Column(
      children: [
        ChatHeader(
          title: widget.otherUsername ?? 'Direct Message',
          isConnected: dmState.isConnected,
        ),
        Expanded(
          child: ChatMessageList(
            messages: transformedMessages,
            currentUserId: currentUserId,
            isLoading: isLoading,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        ChatErrorBanner(errorMessage: dmState.errorMessage),
        ChatInputBar(
          controller: _textController,
          onSend: () => _handleSend(dmNotifier),
          maxLines: 5,
          enabled: dmState.isConnected,
        ),
      ],
    );
  }

  void _handleSend(UnifiedDmChatNotifier dmNotifier) {
    final trimmed = _textController.text.trim();
    if (trimmed.isEmpty) return;

    // The notifier's sendMessage already checks state.isConnected
    // DM messages are sent via the socket "send_dm" event.
    // Payload shape expected by the backend SocketService:
    // {
    //   conversationId: string,
    //   message: string,
    //   metadata: {...}
    // }
    dmNotifier.sendMessage({
      'conversationId': widget.conversationId,
      'message': trimmed,
      'metadata': <String, dynamic>{},
    });

    _textController.clear();
  }
}
