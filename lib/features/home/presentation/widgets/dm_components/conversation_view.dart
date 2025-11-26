import 'package:flutter/material.dart';
import 'dm_header.dart';
import '../dm_chat_content.dart';

/// View for an individual conversation
class ConversationView extends StatelessWidget {
  final VoidCallback onBack;
  final String conversationId;
  final String otherUserId;
  final String? otherUsername;

  const ConversationView({
    super.key,
    required this.onBack,
    required this.conversationId,
    required this.otherUserId,
    this.otherUsername,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        DmHeader(
          title: otherUsername ?? 'Conversation',
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            onPressed: onBack,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
        // Chat content
        Expanded(
          child: DmChatContent(
            conversationId: conversationId,
            otherUserId: otherUserId,
            otherUsername: otherUsername,
          ),
        ),
      ],
    );
  }
}
