import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/draft_room_provider.dart';
import '../../domain/draft.dart';
import 'draft_board/draft_status_bar.dart';
import 'draft_board/draft_grid_view.dart';

/// Draft board panel displaying the draft grid and status
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
        DraftStatusBar(
          draft: draftRoomState.draft,
          currentPick: draftRoomState.currentPick,
          currentRound: draftRoomState.currentRound,
          pickDeadline: draftRoomState.pickDeadline,
          pausedAtDeadline: draftRoomState.pausedAtDeadline,
          isAutopickEnabled: draftRoomState.isMyAutopickEnabled,
        ),

        const Divider(height: 1),

        // Draft board grid with managers on X-axis and rounds on Y-axis
        Expanded(
          child: DraftGridView(
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
