import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../drafts/domain/draft.dart';
import '../../application/matchup_drafts_provider.dart';
import 'components/draft_status_bar.dart';
import 'components/matchup_draft_grid.dart';

class MatchupDraftBoardPanel extends ConsumerWidget {
  final int leagueId;
  final int draftId;
  final Draft draft;

  const MatchupDraftBoardPanel({
    super.key,
    required this.leagueId,
    required this.draftId,
    required this.draft,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftRoomState = ref.watch(
      matchupDraftRoomProvider((
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
        ),

        const Divider(height: 1),

        // Draft board - grid
        Expanded(
          child: MatchupDraftGrid(
            draft: draftRoomState.draft,
            picks: draftRoomState.picks,
            draftOrder: draftRoomState.draftOrder,
            currentPick: draftRoomState.currentPick,
          ),
        ),
      ],
    );
  }
}
