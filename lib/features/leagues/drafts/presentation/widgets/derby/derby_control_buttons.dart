import 'package:flutter/material.dart';

/// Control buttons for commissioners to manage derby state
class DerbyControlButtons extends StatelessWidget {
  final String derbyStatus;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onStart;
  final bool showStartButton;

  const DerbyControlButtons({
    super.key,
    required this.derbyStatus,
    required this.onPause,
    required this.onResume,
    required this.onStart,
    this.showStartButton = false,
  });

  @override
  Widget build(BuildContext context) {
    if (showStartButton && derbyStatus != 'in_progress') {
      return Column(
        children: [
          FilledButton.icon(
            onPressed: onStart,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Derby'),
          ),
          const SizedBox(height: 16),
        ],
      );
    }

    if (derbyStatus == 'in_progress' || derbyStatus == 'paused') {
      return Column(
        children: [
          OutlinedButton.icon(
            onPressed: derbyStatus == 'paused' ? onResume : onPause,
            icon: Icon(derbyStatus == 'paused' ? Icons.play_arrow : Icons.pause),
            label: Text(derbyStatus == 'paused' ? 'Resume Derby' : 'Pause Derby'),
          ),
          const SizedBox(height: 16),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
