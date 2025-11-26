import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../direct_messages/presentation/dm_screen.dart';
import '../../../../home/presentation/widgets/dm_chat_content.dart';

/// Wrapper panel for direct messages.
/// Can show either:
/// - List of DM conversations
/// - A specific DM conversation view (wraps DmChatContent)
class LeagueDmPanel extends ConsumerWidget {
  final String? selectedConversationId;
  final String? selectedOtherUserId;
  final String? selectedOtherUsername;
  final VoidCallback onStartNewDm;
  final void Function({
    required String conversationId,
    required String otherUserId,
    String? otherUsername,
  }) onConversationSelected;
  final VoidCallback onBackFromConversation;

  const LeagueDmPanel({
    super.key,
    required this.selectedConversationId,
    required this.selectedOtherUserId,
    required this.selectedOtherUsername,
    required this.onStartNewDm,
    required this.onConversationSelected,
    required this.onBackFromConversation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If a conversation is selected, show it
    if (selectedConversationId != null && selectedOtherUserId != null) {
      return Column(
        children: [
          // Back button header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: onBackFromConversation,
                ),
                Text(
                  selectedOtherUsername ?? 'Direct Message',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Expanded(
            child: DmChatContent(
              conversationId: selectedConversationId!,
              otherUserId: selectedOtherUserId!,
              otherUsername: selectedOtherUsername,
            ),
          ),
        ],
      );
    }

    // Show list of conversations
    final conversationsAsync = ref.watch(dmConversationsProvider);

    return conversationsAsync.when(
      data: (conversations) {
        return Column(
          children: [
            // Search/New Message button
            Container(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton.icon(
                onPressed: onStartNewDm,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Message'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: conversations.isEmpty
                  ? const Center(
                      child: Text(
                        'No direct messages yet',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      itemCount: conversations.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final convo = conversations[index];
                        final conversationId =
                            (convo['conversationId'] ?? '').toString();
                        final otherUserId =
                            (convo['otherUserId'] ?? '').toString();
                        final otherUsername =
                            (convo['otherUsername'])?.toString();
                        final lastMessage = convo['lastMessage']?.toString();
                        final unreadCount = int.tryParse(
                                convo['unreadCount']?.toString() ?? '0') ??
                            0;

                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              otherUsername != null && otherUsername.isNotEmpty
                                  ? otherUsername[0].toUpperCase()
                                  : '?',
                            ),
                          ),
                          title: Text(otherUsername ?? 'Unknown'),
                          subtitle: Text(
                            lastMessage?.isNotEmpty == true
                                ? lastMessage!
                                : 'No messages yet',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: unreadCount > 0
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    unreadCount.toString(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 11),
                                  ),
                                )
                              : null,
                          onTap: () => onConversationSelected(
                            conversationId: conversationId,
                            otherUserId: otherUserId,
                            otherUsername: otherUsername,
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'Failed to load conversations',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}