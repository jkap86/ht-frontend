import 'package:flutter/material.dart';
import '../../domain/available_matchup.dart';
import 'matchup_card.dart';

/// List view displaying available matchups
class MatchupListView extends StatelessWidget {
  final List<AvailableMatchup> matchups;
  final bool canMakePick;
  final Future<void> Function(int opponentRosterId, int weekNumber) onMakeMatchupPick;

  const MatchupListView({
    super.key,
    required this.matchups,
    required this.canMakePick,
    required this.onMakeMatchupPick,
  });

  @override
  Widget build(BuildContext context) {
    if (matchups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No matchups available',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).disabledColor,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      itemCount: matchups.length,
      itemBuilder: (context, index) {
        final matchup = matchups[index];
        return MatchupCard(
          matchup: matchup,
          canMakePick: canMakePick,
          onPick: () async {
            try {
              await onMakeMatchupPick(
                matchup.opponentRosterId,
                matchup.weekNumber,
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Picked ${matchup.opponentUsername ?? "Roster ${matchup.opponentRosterNumber}"} for Week ${matchup.weekNumber}',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to make pick: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        );
      },
    );
  }
}
