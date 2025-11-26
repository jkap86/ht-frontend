import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/unified_league_chat_notifier.dart';
import 'chat_content.dart';
import '../../../../../shared/widgets/collapsible/collapsible_widget.dart';
import '../../../../../core/chat/chat_state.dart';

/// Collapsible league chat widget that can be expanded to varying sizes or collapsed to an icon
class CollapsibleChatWidget extends CollapsibleWidget {
  final int leagueId;
  final String? leagueName;

  const CollapsibleChatWidget({
    super.key,
    required this.leagueId,
    this.leagueName,
  }) : super(stateKey: 'league_chat_$leagueId');

  @override
  ConsumerState<CollapsibleChatWidget> createState() =>
      _CollapsibleChatWidgetState();
}

class _CollapsibleChatWidgetState
    extends CollapsibleWidgetState<CollapsibleChatWidget> {
  @override
  Widget buildCollapsedIcon(BuildContext context) {
    final chatState = ref.watch(leagueChatNotifierProvider(widget.leagueId));
    final unreadCount = _computeUnread(chatState);

    return InkWell(
      onTap: toggleExpanded,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: widget.collapsedSize,
        height: widget.collapsedSize,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            const Center(
              child: Icon(
                Icons.chat_bubble_outline,
                color: Colors.white,
                size: 28,
              ),
            ),
            if (unreadCount > 0)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Text(
                    unreadCount > 99 ? '99+' : unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildExpandedContent(BuildContext context) {
    return LeagueChatContent(
      leagueId: widget.leagueId,
      leagueName: widget.leagueName,
    );
  }

  @override
  Widget? buildHeader(BuildContext context) {
    final leagueName = widget.leagueName ?? 'League Chat';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.chat_bubble_outline, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              leagueName,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: toggleExpanded,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  @override
  int getUnreadCount() {
    final chatState = ref.watch(leagueChatNotifierProvider(widget.leagueId));
    return _computeUnread(chatState);
  }

  int _computeUnread(ChatState state) {
    // TODO: implement real unread logic
    return 0;
  }
}
