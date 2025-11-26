import 'package:flutter/material.dart';
import '../../../domain/matchup_draft_pick.dart';

/// Individual cell in the matchup draft grid
class MatchupPickCell extends StatelessWidget {
  final MatchupDraftPick pick;
  final bool hasPick;
  final bool isCurrent;
  final bool isFuture;
  final int pickInRound;

  const MatchupPickCell({
    super.key,
    required this.pick,
    required this.hasPick,
    required this.isCurrent,
    required this.isFuture,
    required this.pickInRound,
  });

  @override
  Widget build(BuildContext context) {
    Color? bgColor;
    if (isCurrent) {
      bgColor = Theme.of(context).colorScheme.primaryContainer;
    } else if (isFuture) {
      bgColor = Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);
    }

    // Format pick number as "round.pick" (e.g., "1.01", "2.12")
    final pickLabel = '${pick.roundNumber}.${pickInRound.toString().padLeft(2, '0')}';

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Pick number in top-left corner
          Positioned(
            top: 2,
            left: 2,
            child: Text(
              pickLabel,
              style: TextStyle(
                fontSize: 9,
                color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (hasPick) ...[
                  Text(
                    'R${pick.opponentRosterNumber}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Wk ${pick.weekNumber}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ] else if (isCurrent) ...[
                  Icon(
                    Icons.access_time,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'On Clock',
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ] else if (isFuture) ...[
                  Icon(
                    Icons.lock_outline,
                    size: 20,
                    color: Colors.grey.shade600,
                  ),
                ] else ...[
                  const SizedBox.shrink(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
