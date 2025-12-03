import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/draft_room_provider.dart';
import '../../domain/draft.dart';
import 'draft_board/draft_status_bar.dart';
import 'draft_board/draft_grid_view.dart';

enum DraftGridViewMode { round, rosterPositions }

/// Draft board panel displaying the draft grid and status
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
  DraftGridViewMode _viewMode = DraftGridViewMode.round;
  bool _axisFlipped = false;

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
        DraftStatusBar(
          draft: draftRoomState.draft,
          currentPick: draftRoomState.currentPick,
          currentRound: draftRoomState.currentRound,
          pickDeadline: draftRoomState.pickDeadline,
          pausedAtDeadline: draftRoomState.pausedAtDeadline,
          isAutopickEnabled: draftRoomState.isMyAutopickEnabled,
        ),

        const Divider(height: 1),

        // View mode toggle
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Row(
            children: [
              const Text('View: ', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(width: 8),
              SegmentedButton<DraftGridViewMode>(
                segments: const [
                  ButtonSegment(
                    value: DraftGridViewMode.round,
                    label: Text('Round'),
                    icon: Icon(Icons.grid_view, size: 16),
                  ),
                  ButtonSegment(
                    value: DraftGridViewMode.rosterPositions,
                    label: Text('Roster'),
                    icon: Icon(Icons.people, size: 16),
                  ),
                ],
                selected: {_viewMode},
                onSelectionChanged: (selected) {
                  setState(() {
                    _viewMode = selected.first;
                  });
                },
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: Icon(
                  _axisFlipped ? Icons.swap_vert : Icons.swap_horiz,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _axisFlipped = !_axisFlipped;
                  });
                },
                tooltip: 'Flip axes',
                style: IconButton.styleFrom(
                  backgroundColor: _axisFlipped
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
                ),
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        // Draft board grid with managers on X-axis and rounds on Y-axis
        Expanded(
          child: DraftGridView(
            draft: widget.draft,
            picks: draftRoomState.picks,
            draftOrder: draftRoomState.draftOrder,
            currentPick: draftRoomState.currentPick,
            viewMode: _viewMode,
            axisFlipped: _axisFlipped,
          ),
        ),
      ],
    );
  }
}
