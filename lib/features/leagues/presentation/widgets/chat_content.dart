import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/league_chat_provider.dart';
import 'chat_message_tile.dart';
import '../../../direct_messages/presentation/widgets/dm_conversations_list.dart';
import '../../../direct_messages/presentation/widgets/dm_conversation_view.dart';

enum ChatMode { league, directMessages }

/// Widget displaying chat messages and input field
class ChatContent extends ConsumerStatefulWidget {
  final int leagueId;
  final double opacity;
  final VoidCallback onClose;

  const ChatContent({
    super.key,
    required this.leagueId,
    required this.opacity,
    required this.onClose,
  });

  @override
  ConsumerState<ChatContent> createState() => _ChatContentState();
}

class _ChatContentState extends ConsumerState<ChatContent> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;
  ChatMode _chatMode = ChatMode.league;

  // DM conversation state
  String? _selectedUserId;
  String? _selectedUsername;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _isSending) return;

    setState(() {
      _isSending = true;
    });

    try {
      await ref
          .read(leagueChatProvider(widget.leagueId).notifier)
          .sendMessage(message);
      _messageController.clear();
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(leagueChatProvider(widget.leagueId));

    return Opacity(
      opacity: widget.opacity,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.drag_handle),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _chatMode = _chatMode == ChatMode.league
                              ? ChatMode.directMessages
                              : ChatMode.league;
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _chatMode == ChatMode.league ? 'League Chat' : 'Direct Messages',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.swap_horiz, size: 18),
                        ],
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: widget.onClose,
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Chat messages or DM conversations
          Expanded(
            child: _chatMode == ChatMode.league
                ? chatState.when(
                    data: (messages) {
                      if (messages.isEmpty) {
                        return const Center(
                          child: Text(
                            'No messages yet.\nStart the conversation!',
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => _scrollToBottom());

                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(12),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return ChatMessageTile(message: messages[index]);
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red),
                          const SizedBox(height: 8),
                          Text(
                            'Error loading messages',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => ref
                                .refresh(leagueChatProvider(widget.leagueId)),
                            child: const Text(
                              'Retry',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : _selectedUserId != null && _selectedUsername != null
                    ? DmConversationView(
                        otherUserId: _selectedUserId!,
                        otherUsername: _selectedUsername!,
                        onBack: () {
                          setState(() {
                            _selectedUserId = null;
                            _selectedUsername = null;
                          });
                        },
                      )
                    : DmConversationsList(
                        onConversationSelected: (userId, username) {
                          setState(() {
                            _selectedUserId = userId;
                            _selectedUsername = username;
                          });
                        },
                      ),
          ),

          // Message input (only show for league chat, not for DM conversations list)
          if (_chatMode == ChatMode.league ||
              (_chatMode == ChatMode.directMessages && _selectedUserId == null))
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              child: _chatMode == ChatMode.league
                  ? Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: const InputDecoration(
                              hintText: 'Type a message...',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: _sendMessage,
                          icon: const Icon(Icons.send),
                          style: IconButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
        ],
      ),
    );
  }
}
