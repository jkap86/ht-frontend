import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../direct_messages/application/unified_dm_chat_provider.dart';
import 'dm_chat_content.dart';
import '../../../../core/chat/chat_state.dart';

/// A collapsible DM chat widget that can be embedded in the home screen
/// (e.g., bottom-right corner, similar to a floating messenger bubble).
///
/// It uses [dmChatProvider] + [DmChatContent] under the hood.
class CollapsibleDmChatWidget extends ConsumerStatefulWidget {
  /// The conversation ID, typically something like '${userId}_${otherUserId}'
  /// sorted to ensure stable ordering, and used by the backend/socket room.
  final String conversationId;

  /// The ID of the other user in the DM.
  final String otherUserId;

  /// Optional display name for the other user.
  final String? otherUsername;

  /// Whether the widget should start expanded (open) or collapsed.
  final bool startExpanded;

  const CollapsibleDmChatWidget({
    super.key,
    required this.conversationId,
    required this.otherUserId,
    this.otherUsername,
    this.startExpanded = false,
  });

  @override
  ConsumerState<CollapsibleDmChatWidget> createState() =>
      _CollapsibleDmChatWidgetState();
}

class _CollapsibleDmChatWidgetState
    extends ConsumerState<CollapsibleDmChatWidget> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.startExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final args = UnifiedDmChatProviderArgs(
      conversationId: widget.conversationId,
      otherUserId: widget.otherUserId,
    );
    final dmState = ref.watch(unifiedDmChatProvider(args));
    final unreadCount = _computeUnread(dmState); // TODO: wire real unread later

    // Parent decides positioning (Align/Positioned). This just renders the card.
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: 320,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(
            context,
            unreadCount: unreadCount,
            isExpanded: _isExpanded,
          ),
          if (_isExpanded) _buildExpandedBody(),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context, {
    required int unreadCount,
    required bool isExpanded,
  }) {
    final name = widget.otherUsername ?? 'Direct Message';

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: _toggleExpanded,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey.shade50,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.chat_bubble_outline,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (unreadCount > 0)
              Container(
                margin: const EdgeInsets.only(right: 6),
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
            Icon(
              isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedBody() {
    // Fixed-height chat region; parent chooses overall placement.
    return SizedBox(
      height: 280,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
        child: DmChatContent(
          conversationId: widget.conversationId,
          otherUserId: widget.otherUserId,
          otherUsername: widget.otherUsername,
        ),
      ),
    );
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  /// Placeholder unread-count logic.
  ///
  /// For now this always returns 0. Once you have real unread tracking
  /// (e.g., last read timestamp per conversation), wire that into
  /// [ChatState] and compute it here.
  int _computeUnread(ChatState state) {
    // TODO: implement real unread logic.
    return 0;
  }
}
