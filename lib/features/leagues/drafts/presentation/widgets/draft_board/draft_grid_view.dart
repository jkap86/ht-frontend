import 'package:flutter/material.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';
import '../../../domain/draft.dart';
import '../../../domain/draft_pick.dart';
import '../../../domain/draft_order_entry.dart';
import 'draft_pick_cell.dart';

/// Draft board grid view with managers on X-axis and rounds on Y-axis
class DraftGridView extends StatelessWidget {
  final Draft draft;
  final List<DraftPick> picks;
  final List<DraftOrderEntry> draftOrder;
  final int currentPick;

  const DraftGridView({
    super.key,
    required this.draft,
    required this.picks,
    required this.draftOrder,
    required this.currentPick,
  });

  @override
  Widget build(BuildContext context) {
    if (draftOrder.isEmpty) {
      return const Center(child: CircularProgressIndicator());
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

    // Create a table with managers on X-axis and rounds on Y-axis using TableView
    return TableView.builder(
      pinnedRowCount: 1, // Keep header row sticky
      pinnedColumnCount: 0, // No pinned columns
      columnCount: sortedDraftOrder.length, // One column per manager
      rowCount: draft.rounds + 1, // +1 for header row
      columnBuilder: (index) {
        return const TableSpan(
          extent: FixedTableSpanExtent(150),
        );
      },
      rowBuilder: (index) {
        return TableSpan(
          extent: index == 0
              ? const FixedTableSpanExtent(64) // Header row height
              : const FixedTableSpanExtent(80), // Regular row height
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
        // Header row
        if (vicinity.row == 0) {
          // Manager headers
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
        final isSnakeRound = _isSnakeRound(round);

        // Calculate the pick position for this manager in this round
        final positionInRound = isSnakeRound
            ? (sortedDraftOrder.length - 1 - managerIndex)
            : managerIndex;
        final pickNumber = ((round - 1) * sortedDraftOrder.length) + positionInRound + 1;
        final pickInRound = positionInRound + 1; // 1-indexed for display

        // Find the pick for this slot
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
      },
    );
  }

  bool _isSnakeRound(int round) {
    if (draft.draftType != 'snake') return false;
    if (draft.thirdRoundReversal && round == 3) return true;
    return round % 2 == 0;
  }
}
