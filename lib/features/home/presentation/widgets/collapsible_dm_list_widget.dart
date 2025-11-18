import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../direct_messages/presentation/dm_screen.dart';

/// A collapsible DM list widget that shows in the bottom-right corner
/// of the home screen. When collapsed, shows a chat bubble icon.
/// When expanded, navigates to the full DM screen.
class CollapsibleDmListWidget extends ConsumerStatefulWidget {
  const CollapsibleDmListWidget({super.key});

  @override
  ConsumerState<CollapsibleDmListWidget> createState() =>
      _CollapsibleDmListWidgetState();
}

class _CollapsibleDmListWidgetState
    extends ConsumerState<CollapsibleDmListWidget> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: _buildCollapsedBubble(),
    );
  }

  Widget _buildCollapsedBubble() {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const DmScreen(),
            ),
          );
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
}
