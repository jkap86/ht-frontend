import 'package:flutter/material.dart';
import '../derby/derby_countdown_widget.dart';

/// Banner widget that displays the countdown timer for the current pick deadline
/// Shown during derby when a user's pick timer is active
class PickTimerBanner extends StatelessWidget {
  final DateTime pickDeadline;

  const PickTimerBanner({
    super.key,
    required this.pickDeadline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.timer,
            color: Theme.of(context).colorScheme.secondary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Time to pick:',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                DerbyCountdownWidget(targetTime: pickDeadline),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
