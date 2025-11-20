import 'package:flutter/material.dart';

/// Grid widget for displaying and selecting derby slots
class DerbySlotGrid extends StatelessWidget {
  final List<Map<String, dynamic>> draftOrder;
  final Map<int, Map<String, dynamic>> takenPositions;
  final bool isMyTurn;
  final String derbyStatus;
  final Function(int slotNumber) onSlotSelected;

  const DerbySlotGrid({
    super.key,
    required this.draftOrder,
    required this.takenPositions,
    required this.isMyTurn,
    required this.derbyStatus,
    required this.onSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(draftOrder.length, (index) {
        final slotNumber = index + 1;
        final slotData = takenPositions[slotNumber];
        final isTaken = slotData != null && slotData['username'] != null;

        return SizedBox(
          width: (MediaQuery.of(context).size.width - 80) / 4, // 4 columns
          child: OutlinedButton(
            onPressed: (!isTaken && isMyTurn && derbyStatus == 'in_progress')
                ? () => onSlotSelected(slotNumber)
                : null,
            style: OutlinedButton.styleFrom(
              backgroundColor: isTaken
                  ? Theme.of(context).colorScheme.surfaceContainerHighest
                  : (isMyTurn
                      ? Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withValues(alpha: 0.3)
                      : null),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Slot $slotNumber',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isTaken
                        ? Theme.of(context).colorScheme.onSurfaceVariant
                        : (isMyTurn
                            ? Theme.of(context).colorScheme.primary
                            : null),
                  ),
                ),
                if (isTaken) ...[
                  const SizedBox(height: 4),
                  Text(
                    slotData['username'] ?? 'Taken',
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }
}
