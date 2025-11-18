import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/unified_league_chat_notifier.dart';
import '../../../chat/application/chat_providers.dart';
import 'chat_content.dart';

/// A collapsible league chat widget that can be embedded in the league details
/// screen (e.g., bottom-right corner).
///
/// It uses [leagueChatProvider] + [LeagueChatContent] under the hood.
class CollapsibleChatWidget extends ConsumerStatefulWidget {
  final int leagueId;
  final String? leagueName;
  final bool startExpanded;

  const CollapsibleChatWidget({
    super.key,
    required this.leagueId,
    this.leagueName,
    this.startExpanded = false,
  });

  @override
  ConsumerState<CollapsibleChatWidget> createState() =>
      _CollapsibleChatWidgetState();
}

class _CollapsibleChatWidgetState extends ConsumerState<CollapsibleChatWidget> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.startExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(unifiedLeagueChatProvider(widget.leagueId));
    final unreadCount = _computeUnread(chatState); // TODO: hook real unread.

    // You can control where this sits from the parent (e.g., Align / Positioned).
    // Here we just render the card; parent decides positioning.
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
    final leagueName = widget.leagueName ?? 'League Chat';

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
                leagueName,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
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
    // Fixed height chat region; parent can wrap this widget in a
    // Positioned / Align to keep it on screen.
    return SizedBox(
      height: 280,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
        child: LeagueChatContent(
          leagueId: widget.leagueId,
          leagueName: widget.leagueName,
        ),
      ),
    );
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  /// Placeholder unread-count logic. Right now this just returns 0.
  /// Once you have real unread tracking, wire it into [ChatState]
  /// and compute it here.
  int _computeUnread(ChatState state) {
    // TODO: implement real unread logic (e.g., compare last read timestamp).
    return 0;
  }
}
