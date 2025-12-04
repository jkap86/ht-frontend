import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../application/leagues_provider.dart';
import '../../drafts/application/drafts_provider.dart';
import '../../drafts/domain/draft_pick.dart';
import '../../matchup_drafts/domain/matchup_draft_pick.dart';

/// Dialog showing both teams' lineups for a matchup
class MatchupDetailDialog extends ConsumerWidget {
  final int leagueId;
  final MatchupDraftPick matchup;

  const MatchupDetailDialog({
    super.key,
    required this.leagueId,
    required this.matchup,
  });

  // Standard roster position order for display
  static const _positionOrder = ['QB', 'RB', 'WR', 'TE', 'FLEX', 'SUPER_FLEX', 'K', 'DEF', 'BN', 'IR'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftsAsync = ref.watch(leagueDraftsProvider(leagueId));
    final leagueAsync = ref.watch(leagueByIdProvider(leagueId));

    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: screenWidth, maxHeight: 700),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Week ${matchup.weekNumber} Matchup',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Teams header
              Row(
                children: [
                  Expanded(
                    child: _buildTeamHeader(
                      context,
                      matchup.pickerUsername ?? 'Team ${matchup.pickerRosterNumber ?? matchup.rosterId}',
                      Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      'vs',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _buildTeamHeader(
                      context,
                      matchup.opponentUsername ?? 'Team ${matchup.opponentRosterNumber}',
                      Theme.of(context).colorScheme.secondaryContainer,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Lineups
              Expanded(
                child: leagueAsync.when(
                  data: (league) {
                    final rosterPositions = league.rosterPositions ?? _defaultRosterPositions;
                    return draftsAsync.when(
                      data: (drafts) {
                        if (drafts.isEmpty) {
                          return const Center(child: Text('No draft found'));
                        }

                        final completedDraft = drafts.firstWhere(
                          (d) => d.status == 'completed',
                          orElse: () => drafts.first,
                        );

                        return _buildLineupsSection(context, ref, completedDraft.id, rosterPositions);
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Center(child: Text('Error: $error')),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error loading league: $error')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const Map<String, dynamic> _defaultRosterPositions = {
    'QB': 1,
    'RB': 2,
    'WR': 2,
    'TE': 1,
    'FLEX': 1,
    'K': 1,
    'DEF': 1,
    'BN': 6,
  };

  Widget _buildTeamHeader(BuildContext context, String teamName, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        teamName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildLineupsSection(
    BuildContext context,
    WidgetRef ref,
    int draftId,
    Map<String, dynamic> rosterPositions,
  ) {
    // Use the provider with week to get opponent, projected pts, and actual pts
    final picksAsync = ref.watch(leagueDraftPicksWithStatsProvider((
      leagueId: leagueId,
      draftId: draftId,
      week: matchup.weekNumber,
    )));

    return picksAsync.when(
      data: (picks) {
        final team1Picks = picks.where((p) => p.rosterId == matchup.rosterId).toList();
        final team2Picks = picks.where((p) => p.rosterId == matchup.opponentRosterId).toList();

        // Build lineups for both teams
        final team1Lineup = _buildLineup(team1Picks, rosterPositions);
        final team2Lineup = _buildLineup(team2Picks, rosterPositions);

        return SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildLineupColumn(
                  context,
                  team1Lineup,
                  rosterPositions,
                  Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: _buildLineupColumn(
                  context,
                  team2Lineup,
                  rosterPositions,
                  Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error loading players: $error')),
    );
  }

  /// Build a lineup by assigning players to roster slots
  Map<String, List<DraftPick?>> _buildLineup(
    List<DraftPick> picks,
    Map<String, dynamic> rosterPositions,
  ) {
    final lineup = <String, List<DraftPick?>>{};
    final usedPicks = <DraftPick>{};

    // Initialize slots for each position
    for (final position in _positionOrder) {
      final count = (rosterPositions[position] as num?)?.toInt() ?? 0;
      if (count > 0) {
        lineup[position] = List.filled(count, null);
      }
    }

    // First pass: Fill exact position matches (QB, RB, WR, TE, K, DEF)
    for (final position in ['QB', 'RB', 'WR', 'TE', 'K', 'DEF']) {
      if (!lineup.containsKey(position)) continue;

      final eligiblePicks = picks
          .where((p) => !usedPicks.contains(p) && p.playerPosition?.toUpperCase() == position)
          .toList();

      for (var i = 0; i < lineup[position]!.length && i < eligiblePicks.length; i++) {
        lineup[position]![i] = eligiblePicks[i];
        usedPicks.add(eligiblePicks[i]);
      }
    }

    // Second pass: Fill FLEX slots (RB/WR/TE)
    if (lineup.containsKey('FLEX')) {
      final flexEligible = picks
          .where((p) => !usedPicks.contains(p) &&
                       ['RB', 'WR', 'TE'].contains(p.playerPosition?.toUpperCase()))
          .toList();

      for (var i = 0; i < lineup['FLEX']!.length && i < flexEligible.length; i++) {
        lineup['FLEX']![i] = flexEligible[i];
        usedPicks.add(flexEligible[i]);
      }
    }

    // Third pass: Fill SUPER_FLEX slots (QB/RB/WR/TE)
    if (lineup.containsKey('SUPER_FLEX')) {
      final superFlexEligible = picks
          .where((p) => !usedPicks.contains(p) &&
                       ['QB', 'RB', 'WR', 'TE'].contains(p.playerPosition?.toUpperCase()))
          .toList();

      for (var i = 0; i < lineup['SUPER_FLEX']!.length && i < superFlexEligible.length; i++) {
        lineup['SUPER_FLEX']![i] = superFlexEligible[i];
        usedPicks.add(superFlexEligible[i]);
      }
    }

    // Final pass: Fill bench with remaining players
    if (lineup.containsKey('BN')) {
      final remainingPicks = picks.where((p) => !usedPicks.contains(p)).toList();
      for (var i = 0; i < lineup['BN']!.length && i < remainingPicks.length; i++) {
        lineup['BN']![i] = remainingPicks[i];
        usedPicks.add(remainingPicks[i]);
      }
    }

    // IR slots remain empty (not auto-filled)

    return lineup;
  }

  Widget _buildLineupColumn(
    BuildContext context,
    Map<String, List<DraftPick?>> lineup,
    Map<String, dynamic> rosterPositions,
    Color bgColor,
  ) {
    final slots = <Widget>[];

    for (final position in _positionOrder) {
      if (!lineup.containsKey(position)) continue;

      for (var i = 0; i < lineup[position]!.length; i++) {
        final player = lineup[position]![i];
        slots.add(_buildSlotRow(context, position, player, bgColor));
      }
    }

    if (slots.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            'No players',
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: slots,
      ),
    );
  }

  Widget _buildSlotRow(BuildContext context, String slotPosition, DraftPick? player, Color bgColor) {
    final isBench = slotPosition == 'BN' || slotPosition == 'IR';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      margin: const EdgeInsets.symmetric(vertical: 0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Position slot badge
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: isBench
                  ? Colors.grey.shade600
                  : _getPositionColor(slotPosition),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                _formatSlotName(slotPosition),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Player info - 2 lines, fixed height
          Expanded(
            child: SizedBox(
              height: 42,
              child: player != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Line 1: Player name, position, team
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                player.playerName ?? 'Unknown',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${player.playerPosition ?? ''} ${player.playerTeam ?? ''}',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        // Line 2: Opponent and points
                        Row(
                          children: [
                            SizedBox(
                              width: 36,
                              child: Text(
                                player.opponent ?? '',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      player.projectedPts?.toStringAsFixed(1) ?? '-',
                                      style: GoogleFonts.caveat(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).colorScheme.outline,
                                      ),
                                    ),
                                    Text(
                                      player.actualPts?.toStringAsFixed(1) ?? '-',
                                      style: GoogleFonts.orbitron(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Center(
                      child: Text(
                        'Empty',
                        style: TextStyle(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatSlotName(String position) {
    switch (position) {
      case 'SUPER_FLEX':
        return 'SF';
      case 'FLEX':
        return 'FLX';
      default:
        return position;
    }
  }

  Color _getPositionColor(String? position) {
    switch (position?.toUpperCase()) {
      case 'QB':
        return Colors.red;
      case 'RB':
        return Colors.green;
      case 'WR':
        return Colors.blue;
      case 'TE':
        return Colors.orange;
      case 'FLEX':
      case 'FLX':
        return Colors.purple;
      case 'SUPER_FLEX':
      case 'SF':
        return Colors.deepPurple;
      case 'K':
        return Colors.teal;
      case 'DEF':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }
}

/// Show the matchup detail dialog
void showMatchupDetailDialog(
  BuildContext context, {
  required int leagueId,
  required MatchupDraftPick matchup,
}) {
  showDialog(
    context: context,
    builder: (context) => MatchupDetailDialog(
      leagueId: leagueId,
      matchup: matchup,
    ),
  );
}
