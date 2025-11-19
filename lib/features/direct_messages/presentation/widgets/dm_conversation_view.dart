import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/unified_dm_chat_provider.dart';
import '../../../chat/presentation/widgets/chat_message_bubble.dart';
import '../../../chat/presentation/widgets/chat_input_bar.dart';
import '../../../chat/presentation/widgets/chat_error_banner.dart';
import '../../../auth/application/auth_notifier.dart';
import '../../../../core/chat/chat_state.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      }
    });

    final theme = Theme.of(context);
    final isLoading = dmState.isConnecting && dmState.messages.isEmpty;

    return Column(
      children: [
        _buildHeader(theme),
        const Divider(height: 1),
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildMessagesList(dmState),
        ),
        ChatErrorBanner(errorMessage: dmState.errorMessage),
        ChatInputBar(
          controller: _textController,
          onSend: () => _handleSend(dmNotifier),
          maxLines: 5,
        ),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final name = widget.otherUsername ?? 'Direct Message';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          CircleAvatar(
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
            ),
          ),
          const SizedBox(width: 12),
          Text(
            name,
            style: theme.textTheme.titleMedium,
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

    // Get current user ID to determine if message is from me
    final currentUserId = ref.read(authProvider).user?.userId;

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final msg = state.messages[index];

        // Expecting something like:
        // {
        //   "message": "Hello",
        //   "sender_id": "...",
        //   "sender_username": "...",
        //   ...
        // }
        final text = (msg['message'] ?? '').toString();
        final senderId = (msg['sender_id'] ?? '').toString();
        final senderName = (msg['sender_username'] ?? '').toString();
        final isMe = currentUserId != null && senderId == currentUserId;

        return ChatMessageBubble.user(
          text: text,
          username: senderName,
          isMe: isMe,
        );
      },
    );
  }

  void _handleSend(UnifiedDmChatNotifier dmNotifier) {
    final trimmed = _textController.text.trim();
    if (trimmed.isEmpty) return;

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
