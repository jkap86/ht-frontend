import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/unified_league_chat_notifier.dart';
import '../../../chat/application/chat_providers.dart';
import '../../../chat/presentation/widgets/chat_message_bubble.dart';
import '../../../chat/presentation/widgets/chat_input_bar.dart';
import '../../../chat/presentation/widgets/chat_error_banner.dart';

/// Embeddable league chat content widget (no AppBar / Scaffold).
///
/// Use this inside league details screens to show league chat inline.
///
/// Assumptions:
/// - `leagueId` matches what your backend expects for league chat.
/// - Backend payloads have at least:
///     { "message": "...", "username": "...", "message_type": "chat" | "system", ... }
class LeagueChatContent extends ConsumerStatefulWidget {
  final int leagueId;
  final String? leagueName;

  const LeagueChatContent({
    super.key,
    required this.leagueId,
    this.leagueName,
  });

  @override
  ConsumerState<LeagueChatContent> createState() => _LeagueChatContentState();
}

class _LeagueChatContentState extends ConsumerState<LeagueChatContent> {
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
    final state = ref.watch(unifiedLeagueChatProvider(widget.leagueId));
    final notifier = ref.read(unifiedLeagueChatProvider(widget.leagueId).notifier);

    // Auto-scroll to bottom when new messages arrive.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      }
    });

    final isLoading = state.isConnecting && state.messages.isEmpty;

    return Column(
      children: [
        if (widget.leagueName != null) _buildInlineHeader(widget.leagueName!),
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildMessagesList(state),
        ),
        ChatErrorBanner(errorMessage: state.errorMessage),
        ChatInputBar(
          controller: _textController,
          onSend: () => _handleSend(notifier),
        ),
      ],
    );
  }

  Widget _buildInlineHeader(String leagueName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          const Icon(Icons.chat_bubble_outline, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              '$leagueName Chat',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
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
          'No messages yet. Be the first to say something!',
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
        final username = (msg['username'] ?? '').toString();
        final messageType = (msg['message_type'] ?? 'chat').toString();

        final isSystem = messageType == 'system';

        if (isSystem) {
          return ChatMessageBubble.system(text: text);
        }

        return ChatMessageBubble.user(
          text: text,
          username: username,
        );
      },
    );
  }

  void _handleSend(ChatNotifier notifier) {
    final ok = notifier.sendMessage(message: _textController.text);
    if (ok) {
      _textController.clear();
    }
  }
}
