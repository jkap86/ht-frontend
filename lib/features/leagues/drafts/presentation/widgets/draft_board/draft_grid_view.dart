import 'package:flutter/material.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';
import '../../../domain/draft.dart';
import '../../../domain/draft_pick.dart';
import '../../../domain/draft_order_entry.dart';
import '../draft_board_panel.dart';
import 'draft_pick_cell.dart';

/// Draft board grid view with managers on X-axis and rounds on Y-axis
class DraftGridView extends StatelessWidget {
  final Draft draft;
  final List<DraftPick> picks;
  final List<DraftOrderEntry> draftOrder;
  final int currentPick;
  final DraftGridViewMode viewMode;
  final bool axisFlipped;

  const DraftGridView({
    super.key,
    required this.draft,
    required this.picks,
    required this.draftOrder,
    required this.currentPick,
    this.viewMode = DraftGridViewMode.round,
    this.axisFlipped = false,
  });

  @override
  Widget build(BuildContext context) {
    if (draftOrder.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shuffle,
              size: 48,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Draft order not set',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Go to Draft Settings to randomize or configure the draft order',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Sort draft order by actual draft position (not derby pick order)
    final sortedDraftOrder = List<DraftOrderEntry>.from(draftOrder)
      ..sort((a, b) {
        // If both have draft positions, sort by those
        if (a.draftPosition != null && b.draftPosition != null) {
          return a.draftPosition!.compareTo(b.draftPosition!);
        }
        // If one has null draft position, put it at the end
        if (a.draftPosition == null) return 1;
        if (b.draftPosition == null) return -1;
        return 0;
      });

    if (viewMode == DraftGridViewMode.rosterPositions) {
      return _buildRosterPositionsView(context, sortedDraftOrder);
    }

    // Round view - managers on X-axis, rounds on Y-axis (or flipped)
    final numManagers = sortedDraftOrder.length;
    final numRounds = draft.rounds;

    // When flipped: rounds on X-axis, managers on Y-axis (no header row for rounds)
    final columnCount = axisFlipped ? numRounds + 1 : numManagers; // +1 for manager labels when flipped
    final rowCount = axisFlipped ? numManagers : numRounds + 1; // No header row when flipped

    return TableView.builder(
      pinnedRowCount: axisFlipped ? 0 : 1, // No pinned header when flipped
      pinnedColumnCount: axisFlipped ? 1 : 0, // Pin manager column when flipped
      columnCount: columnCount,
      rowCount: rowCount,
      columnBuilder: (index) {
        if (axisFlipped && index == 0) {
          return const TableSpan(extent: FixedTableSpanExtent(120)); // Manager names
        }
        return const TableSpan(extent: FixedTableSpanExtent(150));
      },
      rowBuilder: (index) {
        return TableSpan(
          extent: index == 0
              ? const FixedTableSpanExtent(64)
              : const FixedTableSpanExtent(80),
          foregroundDecoration: index == 0
              ? TableSpanDecoration(
                  border: TableSpanBorder(
                    trailing: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 2,
                    ),
                  ),
                )
              : null,
        );
      },
      cellBuilder: (context, vicinity) {
        if (axisFlipped) {
          return _buildFlippedRoundCell(context, vicinity, sortedDraftOrder);
        }
        return _buildNormalRoundCell(context, vicinity, sortedDraftOrder);
      },
    );
  }

  /// Build cell for normal round view (managers on X, rounds on Y)
  TableViewCell _buildNormalRoundCell(
    BuildContext context,
    TableVicinity vicinity,
    List<DraftOrderEntry> sortedDraftOrder,
  ) {
    // Header row
    if (vicinity.row == 0) {
      final managerIndex = vicinity.column;
      final manager = sortedDraftOrder[managerIndex];
      return TableViewCell(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            border: Border.all(
              color: Theme.of(context).dividerColor,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                manager.username ?? 'Manager',
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                manager.draftPosition != null ? '#${manager.draftPosition}' : 'TBD',
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Pick cells
    final round = vicinity.row;
    final managerIndex = vicinity.column;
    return _buildPickCell(context, round, managerIndex, sortedDraftOrder);
  }

  /// Build cell for flipped round view (rounds on X, managers on Y)
  TableViewCell _buildFlippedRoundCell(
    BuildContext context,
    TableVicinity vicinity,
    List<DraftOrderEntry> sortedDraftOrder,
  ) {
    // Manager column (first column)
    if (vicinity.column == 0) {
      final managerIndex = vicinity.row;
      final manager = sortedDraftOrder[managerIndex];
      return TableViewCell(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            border: Border.all(color: Theme.of(context).dividerColor, width: 1),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                manager.username ?? 'Manager',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '#${manager.draftPosition ?? "TBD"}',
                style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodySmall?.color),
              ),
            ],
          ),
        ),
      );
    }

    // Pick cells - round is column (1-indexed), manager is row
    final round = vicinity.column;
    final managerIndex = vicinity.row;
    return _buildPickCell(context, round, managerIndex, sortedDraftOrder);
  }

  /// Build a pick cell for a given round and manager
  TableViewCell _buildPickCell(
    BuildContext context,
    int round,
    int managerIndex,
    List<DraftOrderEntry> sortedDraftOrder,
  ) {
    final isSnakeRound = _isSnakeRound(round);
    final positionInRound = isSnakeRound
        ? (sortedDraftOrder.length - 1 - managerIndex)
        : managerIndex;
    final pickNumber = ((round - 1) * sortedDraftOrder.length) + positionInRound + 1;
    final pickInRound = positionInRound + 1;

    final pick = picks.firstWhere(
      (p) => p.pickNumber == pickNumber,
      orElse: () => DraftPick(
        id: 0,
        draftId: draft.id,
        pickNumber: pickNumber,
        roundNumber: round,
        rosterId: sortedDraftOrder[managerIndex].rosterId,
        pickedAt: DateTime.now(),
      ),
    );

    final hasPick = pick.playerId != null;
    final isFuturePick = pickNumber > currentPick;
    final isCurrentPick = pickNumber == currentPick;

    return TableViewCell(
      child: DraftPickCell(
        pick: pick,
        hasPick: hasPick,
        isCurrent: isCurrentPick,
        isFuture: isFuturePick,
        pickInRound: pickInRound,
      ),
    );
  }

  bool _isSnakeRound(int round) {
    if (draft.draftType != 'snake') return false;
    if (draft.thirdRoundReversal && round == 3) return true;
    return round % 2 == 0;
  }

  /// Build roster positions view - managers on X-axis, roster slots on Y-axis (or flipped)
  Widget _buildRosterPositionsView(
    BuildContext context,
    List<DraftOrderEntry> sortedDraftOrder,
  ) {
    final rosterSlots = _buildRosterSlots();

    // Build a map of rosterId -> list of picks for that roster
    final picksByRoster = <int, List<DraftPick>>{};
    for (final entry in sortedDraftOrder) {
      picksByRoster[entry.rosterId] = picks
          .where((p) => p.rosterId == entry.rosterId && p.playerId != null)
          .toList()
        ..sort((a, b) => a.pickNumber.compareTo(b.pickNumber));
    }

    // For each roster, assign picks to slots based on position
    final rosterSlotAssignments = <int, Map<String, DraftPick?>>{};
    for (final entry in sortedDraftOrder) {
      rosterSlotAssignments[entry.rosterId] =
          _assignPicksToSlots(picksByRoster[entry.rosterId] ?? [], rosterSlots);
    }

    final numManagers = sortedDraftOrder.length;
    final numSlots = rosterSlots.length;

    // When flipped: slots on X-axis, managers on Y-axis
    final columnCount = axisFlipped ? numSlots + 1 : numManagers + 1;
    final rowCount = axisFlipped ? numManagers + 1 : numSlots + 1;

    return TableView.builder(
      pinnedRowCount: 1,
      pinnedColumnCount: 1,
      columnCount: columnCount,
      rowCount: rowCount,
      columnBuilder: (index) {
        if (index == 0) {
          return TableSpan(extent: FixedTableSpanExtent(axisFlipped ? 120 : 80));
        }
        return TableSpan(extent: FixedTableSpanExtent(axisFlipped ? 150 : 150));
      },
      rowBuilder: (index) {
        return TableSpan(
          extent: index == 0
              ? const FixedTableSpanExtent(50)
              : const FixedTableSpanExtent(70),
          foregroundDecoration: index == 0
              ? TableSpanDecoration(
                  border: TableSpanBorder(
                    trailing: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 2,
                    ),
                  ),
                )
              : null,
        );
      },
      cellBuilder: (context, vicinity) {
        if (axisFlipped) {
          return _buildFlippedRosterCell(
            context, vicinity, sortedDraftOrder, rosterSlots, rosterSlotAssignments,
          );
        }
        return _buildNormalRosterCell(
          context, vicinity, sortedDraftOrder, rosterSlots, rosterSlotAssignments,
        );
      },
    );
  }

  /// Build cell for normal roster view (managers on X, slots on Y)
  TableViewCell _buildNormalRosterCell(
    BuildContext context,
    TableVicinity vicinity,
    List<DraftOrderEntry> sortedDraftOrder,
    List<String> rosterSlots,
    Map<int, Map<String, DraftPick?>> rosterSlotAssignments,
  ) {
    // Header row
    if (vicinity.row == 0) {
      if (vicinity.column == 0) {
        return TableViewCell(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              border: Border.all(color: Theme.of(context).dividerColor, width: 1),
            ),
            alignment: Alignment.center,
            child: const Text('Slot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        );
      }
      final managerIndex = vicinity.column - 1;
      final manager = sortedDraftOrder[managerIndex];
      return TableViewCell(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            border: Border.all(color: Theme.of(context).dividerColor, width: 1),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Text(
            manager.username ?? 'Manager',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    // Slot label column
    if (vicinity.column == 0) {
      final slot = rosterSlots[vicinity.row - 1];
      return TableViewCell(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            border: Border.all(color: Theme.of(context).dividerColor, width: 1),
          ),
          alignment: Alignment.center,
          child: Text(slot, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
        ),
      );
    }

    // Player cells
    final managerIndex = vicinity.column - 1;
    final slotIndex = vicinity.row - 1;
    final slot = rosterSlots[slotIndex];
    final rosterId = sortedDraftOrder[managerIndex].rosterId;
    final pick = rosterSlotAssignments[rosterId]?[slot];

    return _buildRosterPickCell(context, pick);
  }

  /// Build cell for flipped roster view (slots on X, managers on Y)
  TableViewCell _buildFlippedRosterCell(
    BuildContext context,
    TableVicinity vicinity,
    List<DraftOrderEntry> sortedDraftOrder,
    List<String> rosterSlots,
    Map<int, Map<String, DraftPick?>> rosterSlotAssignments,
  ) {
    // Header row - slot names
    if (vicinity.row == 0) {
      if (vicinity.column == 0) {
        return TableViewCell(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              border: Border.all(color: Theme.of(context).dividerColor, width: 1),
            ),
            alignment: Alignment.center,
            child: const Text('Manager', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        );
      }
      final slot = rosterSlots[vicinity.column - 1];
      return TableViewCell(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            border: Border.all(color: Theme.of(context).dividerColor, width: 1),
          ),
          alignment: Alignment.center,
          child: Text(slot, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
        ),
      );
    }

    // Manager column
    if (vicinity.column == 0) {
      final managerIndex = vicinity.row - 1;
      final manager = sortedDraftOrder[managerIndex];
      return TableViewCell(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            border: Border.all(color: Theme.of(context).dividerColor, width: 1),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Text(
            manager.username ?? 'Manager',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    // Player cells - slot is now column, manager is now row
    final slotIndex = vicinity.column - 1;
    final managerIndex = vicinity.row - 1;
    final slot = rosterSlots[slotIndex];
    final rosterId = sortedDraftOrder[managerIndex].rosterId;
    final pick = rosterSlotAssignments[rosterId]?[slot];

    return _buildRosterPickCell(context, pick);
  }

  /// Build a roster pick cell
  TableViewCell _buildRosterPickCell(BuildContext context, DraftPick? pick) {
    return TableViewCell(
      child: Container(
        decoration: BoxDecoration(
          color: pick != null
              ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3)
              : Theme.of(context).colorScheme.surface,
          border: Border.all(color: Theme.of(context).dividerColor, width: 0.5),
        ),
        padding: const EdgeInsets.all(6.0),
        child: pick != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pick.playerName ?? 'Unknown',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${pick.playerPosition ?? ''} - ${pick.playerTeam ?? ''}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Rd ${pick.roundNumber}, #${pick.pickNumber}',
                    style: TextStyle(
                      fontSize: 9,
                      color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              )
            : Center(
                child: Text(
                  '-',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.5),
                  ),
                ),
              ),
      ),
    );
  }

  /// Build the list of roster slots based on typical fantasy football positions
  List<String> _buildRosterSlots() {
    // Standard roster configuration - this could be enhanced to use league settings
    return [
      'QB',
      'RB1',
      'RB2',
      'WR1',
      'WR2',
      'WR3',
      'TE',
      'FLEX',
      'K',
      'DEF',
      'BN1',
      'BN2',
      'BN3',
      'BN4',
      'BN5',
      'BN6',
    ];
  }

  /// Assign picks to roster slots based on player position
  Map<String, DraftPick?> _assignPicksToSlots(
    List<DraftPick> rosterPicks,
    List<String> slots,
  ) {
    final assignments = <String, DraftPick?>{};
    final usedPicks = <int>{};

    // Initialize all slots as empty
    for (final slot in slots) {
      assignments[slot] = null;
    }

    // First pass: assign to primary position slots
    for (final pick in rosterPicks) {
      if (usedPicks.contains(pick.id)) continue;

      final position = pick.playerPosition?.toUpperCase() ?? '';

      // Find matching slot
      String? matchingSlot;

      if (position == 'QB' && assignments['QB'] == null) {
        matchingSlot = 'QB';
      } else if (position == 'RB') {
        if (assignments['RB1'] == null) {
          matchingSlot = 'RB1';
        } else if (assignments['RB2'] == null) {
          matchingSlot = 'RB2';
        }
      } else if (position == 'WR') {
        if (assignments['WR1'] == null) {
          matchingSlot = 'WR1';
        } else if (assignments['WR2'] == null) {
          matchingSlot = 'WR2';
        } else if (assignments['WR3'] == null) {
          matchingSlot = 'WR3';
        }
      } else if (position == 'TE' && assignments['TE'] == null) {
        matchingSlot = 'TE';
      } else if (position == 'K' && assignments['K'] == null) {
        matchingSlot = 'K';
      } else if (position == 'DEF' && assignments['DEF'] == null) {
        matchingSlot = 'DEF';
      }

      if (matchingSlot != null) {
        assignments[matchingSlot] = pick;
        usedPicks.add(pick.id);
      }
    }

    // Second pass: assign FLEX-eligible players to FLEX
    for (final pick in rosterPicks) {
      if (usedPicks.contains(pick.id)) continue;

      final position = pick.playerPosition?.toUpperCase() ?? '';
      if (['RB', 'WR', 'TE'].contains(position) && assignments['FLEX'] == null) {
        assignments['FLEX'] = pick;
        usedPicks.add(pick.id);
        break;
      }
    }

    // Third pass: assign remaining to bench
    int benchIndex = 1;
    for (final pick in rosterPicks) {
      if (usedPicks.contains(pick.id)) continue;

      final benchSlot = 'BN$benchIndex';
      if (assignments.containsKey(benchSlot) && assignments[benchSlot] == null) {
        assignments[benchSlot] = pick;
        usedPicks.add(pick.id);
        benchIndex++;
      }
      if (benchIndex > 6) break;
    }

    return assignments;
  }
}
