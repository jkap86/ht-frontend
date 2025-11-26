import 'package:flutter/material.dart';
import '../../../../drafts/domain/draft.dart';
import 'pick_timer.dart';

/// Draft status bar showing current round, pick, and timer
class DraftStatusBar extends StatelessWidget {
  final Draft draft;
  final int currentPick;
  final int currentRound;
  final DateTime? pickDeadline;
  final DateTime? pausedAtDeadline;

  const DraftStatusBar({
    super.key,
    required this.draft,
    required this.currentPick,
    required this.currentRound,
    required this.pickDeadline,
    required this.pausedAtDeadline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        children: [
          Text(
            'Round $currentRound • Pick $currentPick',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          if (draft.status == 'in_progress' && pickDeadline != null)
            PickTimer(deadline: pickDeadline!, isPaused: false),
          if (draft.status == 'paused' && pausedAtDeadline != null)
            PickTimer(deadline: pausedAtDeadline!, isPaused: true),
          if (draft.status == 'completed')
            Text(
              'Draft Complete',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
            ),
        ],
      ),
    );
  }
}
