import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../direct_messages/presentation/dm_screen.dart';
import '../../../direct_messages/presentation/widgets/dm_conversations_list.dart';

/// A collapsible DM list widget that shows in the bottom-right corner
/// of the home screen. When collapsed, shows a chat bubble icon.
/// When expanded, shows the list of DM conversations.
class CollapsibleDmListWidget extends ConsumerStatefulWidget {
  const CollapsibleDmListWidget({super.key});

  @override
  ConsumerState<CollapsibleDmListWidget> createState() =>
      _CollapsibleDmListWidgetState();
}

class _CollapsibleDmListWidgetState
    extends ConsumerState<CollapsibleDmListWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: _isExpanded ? _buildExpandedView() : _buildCollapsedBubble(),
    );
  }

  Widget _buildCollapsedBubble() {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = true;
          });
        },
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(28),
          ),
          child: const Icon(
            Icons.chat_bubble_outline,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedView() {
    final theme = Theme.of(context);
    final conversationsAsync = ref.watch(dmConversationsProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: 320,
      height: 400,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Direct Messages',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 20),
                  onPressed: () {
                    setState(() {
                      _isExpanded = false;
                    });
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          // Conversations list
          Expanded(
            child: conversationsAsync.when(
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
      ),
    );
  }
}
