import 'package:flutter/material.dart';

/// Banner showing current derby picker status
class DerbyStatusBanner extends StatelessWidget {
  final bool isMyTurn;
  final String currentPickerName;

  const DerbyStatusBanner({
    super.key,
    required this.isMyTurn,
    required this.currentPickerName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isMyTurn
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isMyTurn
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isMyTurn ? Icons.touch_app : Icons.schedule,
            size: 20,
            color: isMyTurn
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isMyTurn
                  ? 'Your turn to pick a slot!'
                  : 'Waiting for $currentPickerName to pick...',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isMyTurn
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
