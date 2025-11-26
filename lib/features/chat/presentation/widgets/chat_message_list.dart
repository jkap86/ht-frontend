import 'package:flutter/material.dart';
import 'chat_message_bubble.dart';

/// A reusable chat message list widget that displays messages with auto-scroll.
///
/// This widget provides a scrollable list of chat messages with automatic
/// scrolling to the bottom when new messages arrive.
class ChatMessageList extends StatefulWidget {
  final List<Map<String, dynamic>> messages;
  final String? currentUserId;
  final bool isLoading;
  final VoidCallback? onRefresh;
  final EdgeInsets? padding;

  const ChatMessageList({
    super.key,
    required this.messages,
    this.currentUserId,
    this.isLoading = false,
    this.onRefresh,
    this.padding,
  });

  @override
  State<ChatMessageList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatMessageList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void didUpdateWidget(ChatMessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length != oldWidget.messages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading && widget.messages.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (widget.messages.isEmpty) {
      return Center(
        child: Text(
          'No messages yet',
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: widget.padding ?? const EdgeInsets.all(12),
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final message = widget.messages[index];
        return _buildMessage(message);
      },
    );
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    final messageType = message['type'] as String? ?? 'user';
    final text = message['message'] as String? ?? message['text'] as String? ?? '';
    final username = message['username'] as String?;
    final userId = message['user_id']?.toString();
    final isMe = userId != null && userId == widget.currentUserId;

    if (messageType == 'system') {
      return ChatMessageBubble.system(text: text);
    }

    return ChatMessageBubble.user(
      text: text,
      username: username,
      isMe: isMe,
    );
  }
}
