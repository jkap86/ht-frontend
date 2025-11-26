import 'package:flutter/material.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';
import '../../../../drafts/domain/draft.dart';
import '../../../../drafts/domain/draft_order_entry.dart';
import '../../../domain/matchup_draft_pick.dart';
import 'matchup_pick_cell.dart';

/// Grid displaying the matchup draft board
class MatchupDraftGrid extends StatelessWidget {
  final Draft draft;
  final List<MatchupDraftPick> picks;
  final List<DraftOrderEntry> draftOrder;
  final int currentPick;

  const MatchupDraftGrid({
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

    // Create a table with managers on X-axis and rounds on Y-axis using TableView
    return TableView.builder(
      pinnedRowCount: 1, // Keep header row sticky
      pinnedColumnCount: 0, // No pinned columns
      columnCount: draftOrder.length, // One column per manager
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
          final manager = draftOrder[managerIndex];
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
            ? (draftOrder.length - 1 - managerIndex)
            : managerIndex;
        final pickNumber = ((round - 1) * draftOrder.length) + positionInRound + 1;
        final pickInRound = positionInRound + 1; // 1-indexed for display

        // Find the pick for this slot
        final pick = picks.firstWhere(
          (p) => p.pickNumber == pickNumber,
          orElse: () => MatchupDraftPick(
            id: 0,
            draftId: draft.id,
            pickNumber: pickNumber,
            roundNumber: round,
            rosterId: draftOrder[managerIndex].rosterId,
            opponentRosterId: 0,
            weekNumber: 0,
            opponentUsername: null,
            opponentRosterNumber: '',
            pickedAt: DateTime.now(),
          ),
        );

        final hasPick = pick.opponentRosterId != 0 && pick.opponentRosterNumber.isNotEmpty;
        final isFuturePick = pickNumber > currentPick;
        final isCurrentPick = pickNumber == currentPick;

        return TableViewCell(
          child: MatchupPickCell(
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
