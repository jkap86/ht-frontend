import 'package:flutter/material.dart';

import 'dm_conversation_view.dart';

/// A single row / tile in the DM conversations list.
class DmConversationTile extends StatelessWidget {
  final String conversationId;
  final String otherUserId;
  final String? otherUsername;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;
  final VoidCallback? onTap;

  const DmConversationTile({
    super.key,
    required this.conversationId,
    required this.otherUserId,
    this.otherUsername,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = otherUsername ?? 'Unknown user';

    return ListTile(
      leading: CircleAvatar(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
        ),
      ),
      title: Text(
        name,
        style: theme.textTheme.bodyLarge,
      ),
      subtitle: Text(
        lastMessage?.isNotEmpty == true ? lastMessage! : 'No messages yet',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (lastMessageAt != null)
            Text(
              _formatTime(lastMessageAt!),
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          if (unreadCount > 0) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ],
      ),
      onTap: onTap,
    );
  }

  String _formatTime(DateTime dt) {
    // You can swap this for something fancier (timeago, intl, etc.)
    final now = DateTime.now();
    final difference = now.difference(dt);

    if (difference.inMinutes < 1) return 'now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m';
    if (difference.inHours < 24) return '${difference.inHours}h';
    return '${dt.month}/${dt.day}';
  }
}

/// A list widget that shows multiple DM conversations.
///
/// This widget is intentionally presentation-only. It doesn't fetch data
/// or manage sockets. You pass in:
/// - a list of conversation objects (dynamic / Map),
/// - a function that can build `conversationId`/`otherUserId`/`otherUsername`
///   from each item (if needed),
/// - and it will navigate to [DmConversationView] on tap by default.
class DmConversationsList extends StatelessWidget {
  /// Raw conversation objects, typically from your backend.
  ///
  /// Common shape might be:
  /// {
  ///   "conversationId": "...",
  ///   "otherUserId": "...",
  ///   "otherUsername": "...",
  ///   "lastMessage": "...",
  ///   "lastMessageAt": "2025-11-17T10:00:00Z",
  ///   "unreadCount": 2
  /// }
  final List<dynamic> conversations;

  /// Optional external navigation: if provided, this will be used
  /// instead of the default push to [DmConversationView].
  final void Function(
    BuildContext context,
    String conversationId,
    String otherUserId,
    String? otherUsername,
  )? onOpenConversation;

  const DmConversationsList({
    super.key,
    required this.conversations,
    this.onOpenConversation,
  });

  @override
  Widget build(BuildContext context) {
    if (conversations.isEmpty) {
      return const Center(
        child: Text(
          'No conversations yet.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      itemCount: conversations.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final raw = conversations[index];
        final map = raw is Map ? raw : <String, dynamic>{};

        final conversationId =
            (map['conversationId'] ?? map['id'] ?? '').toString();
        final otherUserId =
            (map['otherUserId'] ?? map['userId'] ?? '').toString();
        final otherUsername =
            (map['otherUsername'] ?? map['username'])?.toString();

        final lastMessage = map['lastMessage']?.toString();
        final unreadCount =
            int.tryParse(map['unreadCount']?.toString() ?? '0') ?? 0;

        DateTime? lastMessageAt;
        final lastAtRaw = map['lastMessageAt'] ?? map['last_message_at'];
        if (lastAtRaw is String && lastAtRaw.isNotEmpty) {
          try {
            lastMessageAt = DateTime.parse(lastAtRaw).toLocal();
          } catch (_) {}
        }

        return DmConversationTile(
          conversationId: conversationId,
          otherUserId: otherUserId,
          otherUsername: otherUsername,
          lastMessage: lastMessage,
          lastMessageAt: lastMessageAt,
          unreadCount: unreadCount,
          onTap: () {
            if (onOpenConversation != null) {
              onOpenConversation!(
                context,
                conversationId,
                otherUserId,
                otherUsername,
              );
            } else {
              // Default navigation: push DmConversationView.
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DmConversationView(
                    conversationId: conversationId,
                    otherUserId: otherUserId,
                    otherUsername: otherUsername,
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
