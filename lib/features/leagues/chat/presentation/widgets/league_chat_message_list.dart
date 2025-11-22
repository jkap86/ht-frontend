import 'package:flutter/material.dart';
import '../../../../chat/presentation/widgets/chat_message_bubble.dart';

/// Message list for league chat
class LeagueChatMessageList extends StatelessWidget {
  final List<Map<String, dynamic>> messages;
  final ScrollController scrollController;
  final bool isLoading;

  const LeagueChatMessageList({
    super.key,
    required this.messages,
    required this.scrollController,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (messages.isEmpty) {
      return const Center(
        child: Text(
          'No messages yet. Be the first to say something!',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];

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
}
