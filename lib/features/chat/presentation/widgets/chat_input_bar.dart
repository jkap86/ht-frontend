import 'package:flutter/material.dart';

/// A reusable chat input bar widget.
///
/// Provides a text field and send button for composing chat messages.
class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final String hintText;
  final int minLines;
  final int maxLines;
  final Color? backgroundColor;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    this.hintText = 'Type a message...',
    this.minLines = 1,
    this.maxLines = 4,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.grey.shade900,
          border: const Border(
            top: BorderSide(color: Colors.black26),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                minLines: minLines,
                maxLines: maxLines,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _handleSend(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _handleSend,
            ),
          ],
        ),
      ),
    );
  }

  void _handleSend() {
    if (controller.text.trim().isEmpty) return;
    onSend();
  }
}
