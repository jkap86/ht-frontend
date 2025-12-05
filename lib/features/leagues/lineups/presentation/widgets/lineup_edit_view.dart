import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/lineup_provider.dart';
import '../../domain/lineup.dart';
import 'player_slot_widget.dart';

/// Two-column lineup edit view with starters on left and bench on right
class LineupEditView extends ConsumerWidget {
  final int leagueId;
  final int rosterId;
  final int week;
  final String season;
  final LineupResponse initialResponse;
  final VoidCallback onSaveComplete;
  final VoidCallback onCancel;

  const LineupEditView({
    super.key,
    required this.leagueId,
    required this.rosterId,
    required this.week,
    required this.season,
    required this.initialResponse,
    required this.onSaveComplete,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editState = ref.watch(lineupEditProvider((
      leagueId: leagueId,
      rosterId: rosterId,
      week: week,
      season: season,
      initialResponse: initialResponse,
    )));

    final notifier = ref.read(lineupEditProvider((
      leagueId: leagueId,
      rosterId: rosterId,
      week: week,
      season: season,
      initialResponse: initialResponse,
    )).notifier);

    final theme = Theme.of(context);

    return Column(
      children: [
        // Error banner
        if (editState.errorMessage != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: theme.colorScheme.errorContainer,
            child: Row(
              children: [
                Icon(Icons.warning, size: 16, color: theme.colorScheme.error),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    editState.errorMessage!,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: () => notifier.clearError(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

        // Instructions
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          child: Row(
            children: [
              Icon(Icons.touch_app, size: 14, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Tap a player to select, then tap another to swap',
                style: TextStyle(
                  fontSize: 11,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        // Two-column layout
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Starters column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildColumnHeader(context, 'Starters', Icons.star),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: editState.starters.map((player) {
                            // For empty slots (playerId: 0), check by slot name
                            final isSelected = player.playerId == 0
                                ? editState.selectedPlayer?.slot == player.slot
                                : editState.selectedPlayer?.playerId == player.playerId;
                            // When bench player is selected, check if this starter slot is eligible
                            final selectedIsOnBench = editState.selectedPlayer != null &&
                                editState.bench.any((p) => p.playerId == editState.selectedPlayer!.playerId);
                            final isEligibleTarget = selectedIsOnBench &&
                                player.slot != null &&
                                PositionEligibility.isEligible(editState.selectedPlayer!.playerPosition, player.slot!);
                            return PlayerSlotWidget(
                              player: player,
                              isSelected: isSelected,
                              isStarter: true,
                              isEligibleTarget: isEligibleTarget,
                              onTap: () => notifier.selectPlayer(player),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Divider
              Container(
                width: 1,
                color: theme.dividerColor,
              ),

              // Bench column - filtered when a starter is selected
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBenchHeader(context, editState),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: _getFilteredBench(editState).map((player) {
                            final isSelected = editState.selectedPlayer?.playerId == player.playerId;
                            return PlayerSlotWidget(
                              player: player,
                              isSelected: isSelected,
                              isStarter: false,
                              onTap: () => notifier.selectPlayer(player),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Bottom action bar
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              top: BorderSide(color: theme.dividerColor),
            ),
          ),
          child: Row(
            children: [
              // Cancel button
              TextButton(
                onPressed: editState.isSaving ? null : onCancel,
                child: const Text('Cancel'),
              ),
              const Spacer(),
              // Clear selection button
              if (editState.selectedPlayer != null)
                TextButton.icon(
                  onPressed: () => notifier.clearSelection(),
                  icon: const Icon(Icons.clear, size: 16),
                  label: const Text('Clear'),
                ),
              const SizedBox(width: 8),
              // Save button
              FilledButton.icon(
                onPressed: editState.isSaving || !editState.hasChanges
                    ? null
                    : () async {
                        final success = await notifier.saveLineup();
                        if (success) {
                          onSaveComplete();
                        }
                      },
                icon: editState.isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save, size: 16),
                label: Text(editState.isSaving ? 'Saving...' : 'Save'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColumnHeader(BuildContext context, String title, IconData icon) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        border: Border(
          bottom: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  /// Build bench header with slot filter info
  Widget _buildBenchHeader(BuildContext context, LineupEditState editState) {
    final theme = Theme.of(context);
    final selectedSlot = _getSelectedStarterSlot(editState);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        border: Border(
          bottom: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.event_seat, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              selectedSlot != null
                  ? 'Eligible for ${_formatSlotName(selectedSlot)}'
                  : 'Bench',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: selectedSlot != null
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Get the slot of the currently selected starter (if any)
  String? _getSelectedStarterSlot(LineupEditState editState) {
    if (editState.selectedPlayer == null) return null;

    // For empty slots (playerId: 0), match by slot name instead
    final isEmptySlot = editState.selectedPlayer!.playerId == 0;
    final selectedStarter = isEmptySlot && editState.selectedPlayer!.slot != null
        ? editState.starters.where(
            (p) => p.slot == editState.selectedPlayer!.slot
          ).firstOrNull
        : editState.starters.where(
            (p) => p.playerId == editState.selectedPlayer!.playerId
          ).firstOrNull;

    return selectedStarter?.slot;
  }

  /// Filter bench players based on selected starter slot
  List<LineupPlayer> _getFilteredBench(LineupEditState editState) {
    final selectedSlot = _getSelectedStarterSlot(editState);

    // If no starter is selected, show all bench players
    if (selectedSlot == null) {
      return editState.bench;
    }

    // Filter to only show bench players eligible for the selected slot
    return editState.bench.where((player) {
      return PositionEligibility.isEligible(player.playerPosition, selectedSlot);
    }).toList();
  }

  String _formatSlotName(String slot) {
    switch (slot.toUpperCase()) {
      case 'SUPER_FLEX':
        return 'SF';
      case 'FLEX':
        return 'FLX';
      default:
        return slot;
    }
  }
}
