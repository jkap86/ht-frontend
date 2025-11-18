import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../direct_messages/application/unified_dm_chat_provider.dart';
import '../../../chat/application/chat_providers.dart';
import '../../../chat/presentation/widgets/chat_message_bubble.dart';
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

    // Auto-scroll to bottom when messages change.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      }
    });

    final isLoading = dmState.isConnecting && dmState.messages.isEmpty;

    return Column(
      children: [
        // Optional: small inline header; comment this out if you don't want it
        if (widget.otherUsername != null)
          _buildInlineHeader(widget.otherUsername!),
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildMessagesList(dmState),
        ),
        ChatErrorBanner(errorMessage: dmState.errorMessage),
        ChatInputBar(
          controller: _textController,
          onSend: () => _handleSend(dmNotifier),
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

  Widget _buildMessagesList(ChatState state) {
    if (state.messages.isEmpty) {
      return const Center(
        child: Text(
          'No messages yet. Say hi!',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final msg = state.messages[index];

        final text = (msg['message'] ?? '').toString();
        final senderName = (msg['sender_username'] ?? '').toString();

        // TODO: if you have the current user's ID, set isMe based on:
        // final myUserId = ref.read(authUserProvider)?.id;
        // final isMe = msg['sender_id'] == myUserId;
        const isMe = false;

        return ChatMessageBubble.user(
          text: text,
          username: senderName,
          isMe: isMe,
        );
      },
    );
  }

  void _handleSend(ChatNotifier dmNotifier) {
    final ok = dmNotifier.sendMessage(message: _textController.text);
    if (ok) {
      _textController.clear();
    }
  }
}
