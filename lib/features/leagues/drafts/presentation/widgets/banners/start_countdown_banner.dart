import 'package:flutter/material.dart';
import '../derby/derby_countdown_widget.dart';

/// Banner widget that displays the countdown until the derby starts
/// Shown before the derby begins to inform users when picking will start
class StartCountdownBanner extends StatelessWidget {
  final DateTime derbyStartTime;

  const StartCountdownBanner({
    super.key,
    required this.derbyStartTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.timer,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Derby starts in:',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                DerbyCountdownWidget(targetTime: derbyStartTime),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
