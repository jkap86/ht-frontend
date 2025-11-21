import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';
import '../../application/draft_room_provider.dart';
import '../../domain/draft.dart';
import '../../domain/draft_pick.dart';
import '../../domain/draft_order_entry.dart';

class DraftBoardPanel extends ConsumerWidget {
  final int leagueId;
  final int draftId;
  final Draft draft;

  const DraftBoardPanel({
    super.key,
    required this.leagueId,
    required this.draftId,
    required this.draft,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftRoomState = ref.watch(
      draftRoomProvider((
        leagueId: leagueId,
        draftId: draftId,
        draft: draft,
      )),
    );

    return Column(
      children: [
        // Draft status bar
        _DraftStatusBar(
          draft: draftRoomState.draft,
          currentPick: draftRoomState.currentPick,
          currentRound: draftRoomState.currentRound,
          pickDeadline: draftRoomState.pickDeadline,
        ),

        const Divider(height: 1),

        // Draft board grid with managers on X-axis and rounds on Y-axis
        Expanded(
          child: _DraftGrid(
            draft: draft,
            picks: draftRoomState.picks,
            draftOrder: draftRoomState.draftOrder,
            currentPick: draftRoomState.currentPick,
          ),
        ),
      ],
    );
  }
}

class _DraftStatusBar extends StatelessWidget {
  final Draft draft;
  final int currentPick;
  final int currentRound;
  final DateTime? pickDeadline;

  const _DraftStatusBar({
    required this.draft,
    required this.currentPick,
    required this.currentRound,
    required this.pickDeadline,
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
            _PickTimer(deadline: pickDeadline!),
          if (draft.status == 'paused')
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pause, size: 20),
                SizedBox(width: 8),
                Text('Draft Paused'),
              ],
            ),
        ],
      ),
    );
  }
}

class _PickTimer extends StatefulWidget {
  final DateTime deadline;

  const _PickTimer({required this.deadline});

  @override
  State<_PickTimer> createState() => _PickTimerState();
}

class _PickTimerState extends State<_PickTimer> {
  late Stream<Duration> _timerStream;

  @override
  void initState() {
    super.initState();
    _timerStream = Stream.periodic(
      const Duration(seconds: 1),
      (_) {
        final now = DateTime.now();
        final diff = widget.deadline.difference(now);
        return diff.isNegative ? Duration.zero : diff;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: _timerStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final duration = snapshot.data!;
        final minutes = duration.inMinutes;
        final seconds = duration.inSeconds % 60;

        final isLowTime = duration.inSeconds <= 30;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timer,
              size: 20,
              color: isLowTime ? Colors.red : null,
            ),
            const SizedBox(width: 8),
            Text(
              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isLowTime ? Colors.red : null,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DraftGrid extends StatelessWidget {
  final Draft draft;
  final List<DraftPick> picks;
  final List<DraftOrderEntry> draftOrder;
  final int currentPick;

  const _DraftGrid({
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
      pinnedColumnCount: 1, // Keep round number column sticky
      columnCount: draftOrder.length + 1, // +1 for round number column
      rowCount: draft.rounds + 1, // +1 for header row
      columnBuilder: (index) {
        return TableSpan(
          extent: const FixedTableSpanExtent(150),
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
      rowBuilder: (index) {
        return TableSpan(
          extent: index == 0
              ? const FixedTableSpanExtent(60) // Header row height
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
          if (vicinity.column == 0) {
            // Top-left corner: "Round" label
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
                child: const Center(
                  child: Text(
                    'Round',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          } else {
            // Manager headers
            final managerIndex = vicinity.column - 1;
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
                      '#${manager.draftPosition}',
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
        }

        // Round number column
        if (vicinity.column == 0) {
          final round = vicinity.row;
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
              child: Center(
                child: Text(
                  '$round',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        }

        // Pick cells
        final round = vicinity.row;
        final managerIndex = vicinity.column - 1;
        final isSnakeRound = _isSnakeRound(round);

        // Calculate the pick position for this manager in this round
        final positionInRound = isSnakeRound
            ? (draftOrder.length - 1 - managerIndex)
            : managerIndex;
        final pickNumber = ((round - 1) * draftOrder.length) + positionInRound + 1;

        // Find the pick for this slot
        final pick = picks.firstWhere(
          (p) => p.pickNumber == pickNumber,
          orElse: () => DraftPick(
            id: 0,
            draftId: draft.id,
            pickNumber: pickNumber,
            roundNumber: round,
            rosterId: draftOrder[managerIndex].rosterId,
            pickedAt: DateTime.now(),
          ),
        );

        final hasPick = pick.playerId != null;
        final isFuturePick = pickNumber > currentPick;
        final isCurrentPick = pickNumber == currentPick;

        return TableViewCell(
          child: _PickCell(
            pick: pick,
            hasPick: hasPick,
            isCurrent: isCurrentPick,
            isFuture: isFuturePick,
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

class _PickCell extends StatelessWidget {
  final DraftPick pick;
  final bool hasPick;
  final bool isCurrent;
  final bool isFuture;

  const _PickCell({
    required this.pick,
    required this.hasPick,
    required this.isCurrent,
    required this.isFuture,
  });

  @override
  Widget build(BuildContext context) {
    Color? bgColor;
    if (isCurrent) {
      bgColor = Theme.of(context).colorScheme.primaryContainer;
    } else if (isFuture) {
      bgColor = Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (hasPick) ...[
            Text(
              pick.playerName ?? 'Unknown',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              '${pick.playerPosition ?? ''} - ${pick.playerTeam ?? ''}',
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
            if (pick.wasAutoPick == true)
              const Icon(Icons.auto_mode, size: 12, color: Colors.orange),
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
    );
  }
}
