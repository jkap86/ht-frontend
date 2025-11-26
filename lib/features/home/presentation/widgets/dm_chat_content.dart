import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/application/auth_notifier.dart';
import '../../../direct_messages/application/unified_dm_chat_provider.dart';
import '../../../chat/presentation/widgets/chat_message_list.dart';
import '../../../chat/presentation/widgets/chat_input_bar.dart';
import '../../../chat/presentation/widgets/chat_error_banner.dart';

/// Embeddable DM chat content widget (no AppBar / Scaffold).
///
/// Use this inside other screens (like the home view) when you want to show
/// a conversation inline.
///
/// Assumptions:
/// - `conversationId` is the ID used to join the DM socket room
///   (e.g. sorted `${userId}_${otherUserId}`).
/// - `otherUserId` is the ID of the other participant.
/// - Backend DM payloads have at least a `message` field, optionally
///   `sender_id`, `sender_username`, etc.
class DmChatContent extends ConsumerStatefulWidget {
  final String conversationId;
  final String otherUserId;
  final String? otherUsername;

  const DmChatContent({
    super.key,
    required this.conversationId,
    required this.otherUserId,
    this.otherUsername,
  });

  @override
  ConsumerState<DmChatContent> createState() => _DmChatContentState();
}

class _DmChatContentState extends ConsumerState<DmChatContent> {
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
        // Optional: small inline header; comment this out if you don't want it
        if (widget.otherUsername != null)
          _buildInlineHeader(widget.otherUsername!),
        Expanded(
          child: ChatMessageList(
            messages: transformedMessages,
            currentUserId: currentUserId,
            isLoading: isLoading,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          ),
        ),
        ChatErrorBanner(errorMessage: dmState.errorMessage),
        ChatInputBar(
          controller: _textController,
          onSend: () => _handleSend(dmNotifier),
          enabled: dmState.isConnected,
        ),
      ],
    );
  }

  Widget _buildInlineHeader(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _handleSend(UnifiedDmChatNotifier dmNotifier) {
    final message = _textController.text.trim();
    if (message.isEmpty) return;

    // The notifier's sendMessage already checks state.isConnected
    dmNotifier.sendMessage({
      'room': widget.conversationId,
      'message': message,
      'metadata': <String, dynamic>{},
    });

    _textController.clear();
  }
}
