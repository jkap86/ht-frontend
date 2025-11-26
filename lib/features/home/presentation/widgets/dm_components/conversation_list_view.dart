import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../direct_messages/presentation/dm_screen.dart';
import '../../../../direct_messages/presentation/widgets/dm_conversations_list.dart';
import 'dm_header.dart';

/// View showing the list of DM conversations
class ConversationListView extends ConsumerWidget {
  final VoidCallback onClose;
  final VoidCallback onNewConversation;
  final void Function(BuildContext, String, String, String?) onOpenConversation;

  const ConversationListView({
    super.key,
    required this.onClose,
    required this.onNewConversation,
    required this.onOpenConversation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final conversationsAsync = ref.watch(dmConversationsProvider);

    return Column(
      children: [
        // Header
        DmHeader(
          title: 'Direct Messages',
          leading: const Icon(
            Icons.chat_bubble_outline,
            color: Colors.white,
            size: 20,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add, color: Colors.white, size: 20),
              onPressed: onNewConversation,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: 'New conversation',
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 20),
              onPressed: onClose,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        // Conversations list
        Expanded(
          child: conversationsAsync.when(
            data: (conversations) {
              return DmConversationsList(
                conversations: conversations,
                onOpenConversation: onOpenConversation,
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Failed to load conversations',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
