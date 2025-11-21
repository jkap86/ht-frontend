import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/draft_room_provider.dart';
import '../../domain/draft.dart';
import '../../domain/draft_pick.dart';

class DraftBoardPanel extends ConsumerStatefulWidget {
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
  ConsumerState<DraftBoardPanel> createState() => _DraftBoardPanelState();
}

class _DraftBoardPanelState extends ConsumerState<DraftBoardPanel> {
  int _currentRoundView = 1;

  @override
  Widget build(BuildContext context) {
    final draftRoomState = ref.watch(
      draftRoomProvider((
        leagueId: widget.leagueId,
        draftId: widget.draftId,
        draft: widget.draft,
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

        // Round selector
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.draft.rounds,
            itemBuilder: (context, index) {
              final round = index + 1;
              final isSelected = round == _currentRoundView;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ChoiceChip(
                  label: Text('Round $round'),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _currentRoundView = round;
                      });
                    }
                  },
                ),
              );
            },
          ),
        ),

        const Divider(height: 1),

        // Draft board grid
        Expanded(
          child: _DraftGrid(
            leagueId: widget.leagueId,
            draftId: widget.draftId,
            draft: widget.draft,
            picks: draftRoomState.picks,
            round: _currentRoundView,
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
  final int leagueId;
  final int draftId;
  final Draft draft;
  final List<DraftPick> picks;
  final int round;

  const _DraftGrid({
    required this.leagueId,
    required this.draftId,
    required this.draft,
    required this.picks,
    required this.round,
  });

  @override
  Widget build(BuildContext context) {
    // Get picks for this round
    final roundPicks = picks
        .where((pick) => pick.roundNumber == round)
        .toList()
      ..sort((a, b) => a.pickNumber.compareTo(b.pickNumber));

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _calculateColumns(context),
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: draft.totalRosters,
      itemBuilder: (context, index) {
        // Calculate pick number for this slot
        final isSnakeRound = _isSnakeRound(round);
        final slotIndex = isSnakeRound ? (draft.totalRosters - 1 - index) : index;
        final pickNumber = ((round - 1) * draft.totalRosters) + slotIndex + 1;

        // Find the pick for this slot
        final pick = roundPicks.firstWhere(
          (p) => p.pickNumber == pickNumber,
          orElse: () => DraftPick(
            id: 0,
            draftId: draftId,
            pickNumber: pickNumber,
            roundNumber: round,
            rosterId: 0,
            pickedAt: DateTime.now(),
          ),
        );

        final hasPick = pick.playerId != null;
        final isFuturePick = pickNumber > picks.length;
        final isCurrentPick = !hasPick && pickNumber == picks.length + 1;

        return _PickSlot(
          pick: pick,
          hasPick: hasPick,
          isCurrent: isCurrentPick,
          isFuture: isFuturePick,
        );
      },
    );
  }

  bool _isSnakeRound(int round) {
    if (draft.draftType != 'snake') return false;
    if (draft.thirdRoundReversal && round == 3) return true;
    return round % 2 == 0;
  }

  int _calculateColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 6;
    if (width > 800) return 4;
    if (width > 600) return 3;
    return 2;
  }
}

class _PickSlot extends StatelessWidget {
  final DraftPick pick;
  final bool hasPick;
  final bool isCurrent;
  final bool isFuture;

  const _PickSlot({
    required this.pick,
    required this.hasPick,
    required this.isCurrent,
    required this.isFuture,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isCurrent
          ? Theme.of(context).colorScheme.primaryContainer
          : isFuture
              ? Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
              : null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pick ${pick.pickNumber}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (pick.wasAutoPick == true)
                  const Icon(Icons.auto_mode, size: 16, color: Colors.orange),
              ],
            ),
            const SizedBox(height: 4),
            if (hasPick) ...[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      pick.playerName ?? 'Unknown',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${pick.playerPosition ?? ''} ${pick.playerTeam ?? ''}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (isCurrent) ...[
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time, size: 24),
                      SizedBox(height: 4),
                      Text(
                        'On the clock',
                        style: TextStyle(fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ] else if (isFuture) ...[
              const Expanded(
                child: Center(
                  child: Icon(Icons.lock_outline, size: 24, color: Colors.grey),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
