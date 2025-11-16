import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/dm_provider.dart';

/// Widget displaying list of DM conversations
class DmConversationsList extends ConsumerWidget {
  final Function(String userId, String username) onConversationSelected;

  const DmConversationsList({
    super.key,
    required this.onConversationSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsState = ref.watch(conversationsProvider);

    return conversationsState.when(
      data: (conversations) {
        if (conversations.isEmpty) {
          return const Center(
            child: Text(
              'No conversations yet.\nSend a message to start chatting!',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: conversations.length,
          itemBuilder: (context, index) {
            final conversation = conversations[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(
                    conversation.otherUsername.isNotEmpty
                        ? conversation.otherUsername[0].toUpperCase()
                        : '?',
                  ),
                ),
                title: Text(
                  conversation.otherUsername,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  conversation.lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: conversation.unreadCount > 0
                        ? Theme.of(context).colorScheme.onSurface
                        : Colors.grey,
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatTime(conversation.lastMessageTime),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (conversation.unreadCount > 0) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          conversation.unreadCount.toString(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                onTap: () => onConversationSelected(
                  conversation.otherUserId,
                  conversation.otherUsername,
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(height: 8),
            Text(
              'Error loading conversations',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => ref.refresh(conversationsProvider),
              child: const Text(
                'Retry',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
