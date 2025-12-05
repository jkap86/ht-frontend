import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../application/leagues_provider.dart';
import '../../matchup_drafts/domain/matchup_draft_pick.dart';
import '../../lineups/application/lineup_provider.dart';
import '../../lineups/domain/lineup.dart';
import '../../lineups/presentation/widgets/lineup_edit_view.dart';

/// Dialog showing both teams' lineups for a matchup
class MatchupDetailDialog extends ConsumerStatefulWidget {
  final int leagueId;
  final MatchupDraftPick matchup;

  const MatchupDetailDialog({
    super.key,
    required this.leagueId,
    required this.matchup,
  });

  @override
  ConsumerState<MatchupDetailDialog> createState() => _MatchupDetailDialogState();
}

class _MatchupDetailDialogState extends ConsumerState<MatchupDetailDialog> {
  bool _isEditMode = false;
  int? _editingRosterId;

  // Standard roster position order for display
  static const _positionOrder = ['QB', 'RB', 'WR', 'TE', 'FLEX', 'SUPER_FLEX', 'K', 'DEF', 'BN', 'IR'];

  @override
  Widget build(BuildContext context) {
    final leagueAsync = ref.watch(leagueByIdProvider(widget.leagueId));
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: screenWidth, maxHeight: 700),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: leagueAsync.when(
            data: (league) => _buildDialogContent(context, league),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error loading league: $error')),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogContent(BuildContext context, league) {
    final userRosterId = league.userRosterId;
    final isCommissioner = league.isCommissioner;

    // Determine if user can edit a team
    final canEditTeam1 = userRosterId == widget.matchup.rosterId || isCommissioner;
    final canEditTeam2 = userRosterId == widget.matchup.opponentRosterId || isCommissioner;

    if (_isEditMode && _editingRosterId != null) {
      return _buildEditMode(context, league);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Week ${widget.matchup.weekNumber} Matchup',
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

        // Teams header with edit buttons
        Row(
          children: [
            Expanded(
              child: _buildTeamHeaderWithEdit(
                context,
                widget.matchup.pickerUsername ?? 'Team ${widget.matchup.pickerRosterNumber ?? widget.matchup.rosterId}',
                Theme.of(context).colorScheme.primaryContainer,
                canEdit: canEditTeam1,
                onEdit: () => _enterEditMode(widget.matchup.rosterId),
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
              child: _buildTeamHeaderWithEdit(
                context,
                widget.matchup.opponentUsername ?? 'Team ${widget.matchup.opponentRosterNumber}',
                Theme.of(context).colorScheme.secondaryContainer,
                canEdit: canEditTeam2,
                onEdit: () => _enterEditMode(widget.matchup.opponentRosterId),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Lineups
        Expanded(
          child: _buildLineupsView(context, league),
        ),
      ],
    );
  }

  Widget _buildEditMode(BuildContext context, league) {
    final lineupAsync = ref.watch(lineupProvider((
      leagueId: widget.leagueId,
      rosterId: _editingRosterId!,
      week: widget.matchup.weekNumber,
      season: league.season,
    )));

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _exitEditMode,
                  tooltip: 'Back to matchup',
                ),
                Text(
                  'Edit Lineup - Week ${widget.matchup.weekNumber}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        const Divider(),

        // Lineup edit view
        Expanded(
          child: lineupAsync.when(
            data: (lineupResponse) => LineupEditView(
              leagueId: widget.leagueId,
              rosterId: _editingRosterId!,
              week: widget.matchup.weekNumber,
              season: league.season,
              initialResponse: lineupResponse,
              onSaveComplete: () {
                // Invalidate the lineup provider to refresh data
                ref.invalidate(lineupProvider((
                  leagueId: widget.leagueId,
                  rosterId: _editingRosterId!,
                  week: widget.matchup.weekNumber,
                  season: league.season,
                )));
                _exitEditMode();
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lineup saved successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              onCancel: _exitEditMode,
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error loading lineup: $error'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _exitEditMode,
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLineupsView(BuildContext context, league) {
    // Fetch saved lineups for both teams
    final team1LineupAsync = ref.watch(lineupProvider((
      leagueId: widget.leagueId,
      rosterId: widget.matchup.rosterId,
      week: widget.matchup.weekNumber,
      season: league.season,
    )));
    final team2LineupAsync = ref.watch(lineupProvider((
      leagueId: widget.leagueId,
      rosterId: widget.matchup.opponentRosterId,
      week: widget.matchup.weekNumber,
      season: league.season,
    )));

    return team1LineupAsync.when(
      data: (team1Lineup) => team2LineupAsync.when(
        data: (team2Lineup) => SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildLineupColumnFromResponse(
                  context,
                  team1Lineup,
                  Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: _buildLineupColumnFromResponse(
                  context,
                  team2Lineup,
                  Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error loading opponent lineup: $error')),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error loading lineup: $error')),
    );
  }

  void _enterEditMode(int rosterId) {
    setState(() {
      _isEditMode = true;
      _editingRosterId = rosterId;
    });
  }

  void _exitEditMode() {
    setState(() {
      _isEditMode = false;
      _editingRosterId = null;
    });
  }

  Widget _buildTeamHeaderWithEdit(
    BuildContext context,
    String teamName,
    Color bgColor, {
    required bool canEdit,
    required VoidCallback onEdit,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
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
          ),
          if (canEdit)
            IconButton(
              icon: Icon(
                Icons.edit,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: onEdit,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              tooltip: 'Edit lineup',
            ),
        ],
      ),
    );
  }

  /// Build a lineup column from the API response (uses saved lineup configuration)
  Widget _buildLineupColumnFromResponse(
    BuildContext context,
    LineupResponse response,
    Color bgColor,
  ) {
    final slots = <Widget>[];

    // Group starters by position for ordering
    final startersBySlot = <String, List<LineupPlayer>>{};
    for (final player in response.starters) {
      final slot = player.slot ?? 'BN';
      final baseSlot = slot.replaceAll(RegExp(r'\d+$'), '').toUpperCase();
      startersBySlot.putIfAbsent(baseSlot, () => []).add(player);
    }

    // Add starters in position order
    for (final position in _positionOrder) {
      if (position == 'BN' || position == 'IR') continue;
      final players = startersBySlot[position] ?? [];
      for (final player in players) {
        slots.add(_buildPlayerSlotRow(context, player.slot ?? position, player, bgColor));
      }
    }

    // Add bench players
    for (final player in response.bench) {
      slots.add(_buildPlayerSlotRow(context, 'BN', player, bgColor));
    }

    // Add IR players
    for (final player in response.ir) {
      slots.add(_buildPlayerSlotRow(context, 'IR', player, bgColor));
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

  Widget _buildPlayerSlotRow(BuildContext context, String slotPosition, LineupPlayer player, Color bgColor) {
    final isBench = slotPosition == 'BN' || slotPosition == 'IR';
    final isEmpty = player.playerId == 0;

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
              child: !isEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Line 1: Player name, position, team
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                player.playerName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                  color: player.isLocked
                                      ? Theme.of(context).colorScheme.outline
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${player.playerPosition} ${player.playerTeam}',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            if (player.isLocked)
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Icon(
                                  Icons.lock,
                                  size: 10,
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
