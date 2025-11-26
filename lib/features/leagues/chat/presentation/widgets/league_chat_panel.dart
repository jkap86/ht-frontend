import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/unified_league_chat_notifier.dart';
import '../../../../auth/application/auth_notifier.dart';
import '../../../../chat/presentation/widgets/chat_message_list.dart';
import 'league_chat_input_section.dart';

/// Pure league chat panel.
/// Contains: ChatMessageList + input section
class LeagueChatPanel extends ConsumerStatefulWidget {
  final int leagueId;

  const LeagueChatPanel({
    super.key,
    required this.leagueId,
  });

  @override
  ConsumerState<LeagueChatPanel> createState() => _LeagueChatPanelState();
}

class _LeagueChatPanelState extends ConsumerState<LeagueChatPanel> {
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
    final state = ref.watch(leagueChatNotifierProvider(widget.leagueId));
    final notifier = ref.read(leagueChatNotifierProvider(widget.leagueId).notifier);

    final isLoading = state.isConnecting && state.messages.isEmpty;
    final currentUserId = ref.read(authProvider).user?.userId;

    // Transform messages to include proper field mappings for ChatMessageList
    final transformedMessages = state.messages.map((msg) {
      return {
        'message': msg['message'] ?? '',
        'username': msg['username'] ?? '',
        'user_id': msg['user_id'],
        'type': msg['message_type'] == 'system' ? 'system' : 'user',
      };
    }).toList();

    return Column(
      children: [
        Expanded(
          child: ChatMessageList(
            messages: transformedMessages,
            currentUserId: currentUserId,
            isLoading: isLoading,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          ),
        ),
        LeagueChatInputSection(
          controller: _textController,
          onSend: () => _handleSend(notifier),
          enabled: state.isConnected,
          errorMessage: state.errorMessage,
        ),
      ],
    );
  }

  void _handleSend(LeagueChatNotifier notifier) {
    final message = _textController.text.trim();
    if (message.isEmpty) return;

    // Socket payload expected by backend for league chat:
    // {
    //   room: "league_<id>",
    //   message: string,
    //   metadata: { ... } // optional
    // }
    notifier.sendMessage({
      'room': 'league_${widget.leagueId}',
      'message': message,
      'metadata': <String, dynamic>{},
    });

    _textController.clear();
  }
}