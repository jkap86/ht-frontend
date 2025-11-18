import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/dm_conversations_list.dart';

/// Simple provider that should return the list of DM conversations for the
/// current user.
///
/// TODO:
///   Replace the body of this provider with a real implementation:
///   - Call your REST API
///   - Or read from an existing repository/service
///
/// Expected item shape (but you can adapt as needed):
/// {
///   "conversationId": "...",
///   "otherUserId": "...",
///   "otherUsername": "...",
///   "lastMessage": "...",
///   "lastMessageAt": "2025-11-17T10:00:00Z",
///   "unreadCount": 2
/// }
final dmConversationsProvider = FutureProvider<List<dynamic>>((ref) async {
  // TODO: wire this to your backend.
  // For now, return an empty list so the screen still works.
  return <dynamic>[];
});

/// Main Direct Messages screen.
///
/// Shows a list of conversations. Tapping on a row navigates to the
/// [DmConversationView] for that conversation (handled inside
/// [DmConversationsList] by default).
class DmScreen extends ConsumerWidget {
  const DmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(dmConversationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Direct Messages'),
      ),
      body: conversationsAsync.when(
        data: (conversations) {
          return DmConversationsList(
            conversations: conversations,
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
                'Failed to load conversations:\n$error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
          );
        },
      ),
    );
  }
}
