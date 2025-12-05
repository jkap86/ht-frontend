import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/lineup.dart';

/// Widget for displaying a player in a lineup slot
class PlayerSlotWidget extends StatelessWidget {
  final LineupPlayer player;
  final bool isSelected;
  final bool isStarter;
  final bool isEligibleTarget;
  final VoidCallback onTap;

  const PlayerSlotWidget({
    super.key,
    required this.player,
    required this.isSelected,
    required this.isStarter,
    this.isEligibleTarget = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEmpty = player.playerId == 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : isEligibleTarget
                  ? theme.colorScheme.tertiaryContainer.withValues(alpha: 0.5)
                  : isEmpty
                      ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
                      : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : isEligibleTarget
                    ? theme.colorScheme.tertiary
                    : isEmpty
                        ? theme.colorScheme.outline.withValues(alpha: 0.5)
                        : player.isLocked
                            ? theme.colorScheme.outline.withValues(alpha: 0.3)
                            : Colors.transparent,
            width: isSelected || isEligibleTarget ? 2 : (isEmpty ? 1 : 1),
            style: isEmpty && !isSelected ? BorderStyle.solid : BorderStyle.solid,
          ),
        ),
        child: Row(
          children: [
            // Position badge (for starters)
            if (isStarter && player.slot != null)
              Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: isEmpty
                      ? theme.colorScheme.outline.withValues(alpha: 0.3)
                      : _getSlotColor(player.slot!),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    _formatSlotName(player.slot!),
                    style: TextStyle(
                      color: isEmpty
                          ? theme.colorScheme.outline
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            // Player position badge (for bench)
            if (!isStarter)
              Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: _getPositionColor(player.playerPosition),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    player.playerPosition,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            // Player info - 2 lines with opponent and projections
            Expanded(
              child: isEmpty
                  ? Center(
                      child: Text(
                        'Empty',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 42,
                      child: Column(
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
                                        ? theme.colorScheme.outline
                                        : theme.colorScheme.onSurface,
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
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                              if (player.isLocked)
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Icon(
                                    Icons.lock,
                                    size: 12,
                                    color: theme.colorScheme.outline,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          // Line 2: Opponent and projection
                          Row(
                            children: [
                              Text(
                                player.opponent ?? '',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    player.projectedPts?.toStringAsFixed(1) ?? '-',
                                    style: GoogleFonts.caveat(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
            // Game status indicator
            if (player.gameStatus != null && !isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: player.gameStatus == 'in_progress'
                      ? Colors.green.withValues(alpha: 0.2)
                      : Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  player.gameStatus == 'in_progress' ? 'LIVE' : 'FINAL',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: player.gameStatus == 'in_progress'
                        ? Colors.green
                        : Colors.grey,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatSlotName(String slot) {
    switch (slot.toUpperCase()) {
      case 'SUPER_FLEX':
        return 'SF';
      case 'FLEX':
        return 'FLX';
      default:
        // Remove trailing numbers for display (e.g., QB1 -> QB)
        return slot.replaceAll(RegExp(r'\d+$'), '');
    }
  }

  Color _getSlotColor(String slot) {
    final baseSlot = slot.toUpperCase().replaceAll(RegExp(r'\d+$'), '');
    switch (baseSlot) {
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
      case 'K':
        return Colors.teal;
      case 'DEF':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }
}
