import 'package:flutter/material.dart';

/// A reusable chat message bubble widget.
///
/// Can render both user messages and system messages with appropriate styling.
class ChatMessageBubble extends StatelessWidget {
  final String text;
  final String? username;
  final bool isSystem;
  final bool isMe;
  final Alignment? alignment;

  const ChatMessageBubble({
    super.key,
    required this.text,
    this.username,
    this.isSystem = false,
    this.isMe = false,
    this.alignment,
  });

  /// Factory constructor for system messages (announcements, notifications, etc.)
  factory ChatMessageBubble.system({
    required String text,
  }) {
    return ChatMessageBubble(
      text: text,
      isSystem: true,
    );
  }

  /// Factory constructor for user messages
  factory ChatMessageBubble.user({
    required String text,
    String? username,
    bool isMe = false,
  }) {
    return ChatMessageBubble(
      text: text,
      username: username,
      isSystem: false,
      isMe: isMe,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isSystem) {
      return _buildSystemMessage();
    }
    return _buildUserMessage();
  }

  Widget _buildSystemMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade800.withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildUserMessage() {
    final messageAlignment = alignment ?? (isMe ? Alignment.centerRight : Alignment.centerLeft);
    final color = isMe ? Colors.blueAccent : Colors.grey.shade800;
    final textColor = Colors.white;
    final crossAxisAlignment = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Align(
      alignment: messageAlignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (username != null && username!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  username!,
                  style: TextStyle(
                    color: textColor.withOpacity(0.8),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
