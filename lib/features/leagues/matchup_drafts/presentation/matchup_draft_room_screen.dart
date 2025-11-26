import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/matchup_drafts_provider.dart';
import '../application/matchup_draft_room_notifier.dart';
import 'widgets/matchup_draft_board_panel.dart';
import 'widgets/matchup_selection_panel.dart';
import 'widgets/matchup_draft_commissioner_controls.dart';
import '../../presentation/league_details_screen.dart';

class MatchupDraftRoomScreen extends ConsumerStatefulWidget {
  final int leagueId;
  final int draftId;

  const MatchupDraftRoomScreen({
    super.key,
    required this.leagueId,
    required this.draftId,
  });

  @override
  ConsumerState<MatchupDraftRoomScreen> createState() =>
      _MatchupDraftRoomScreenState();
}

class _MatchupDraftRoomScreenState
    extends ConsumerState<MatchupDraftRoomScreen> {
  @override
  Widget build(BuildContext context) {
    // First, get the matchup draft
    final matchupDraftAsync =
        ref.watch(matchupDraftProvider(widget.leagueId));

    return matchupDraftAsync.when(
      data: (draft) {
        // Listen for draft completion and navigate to league details
        ref.listen(
          matchupDraftRoomProvider((
            leagueId: widget.leagueId,
            draftId: widget.draftId,
            draft: draft,
          )),
          (previous, next) {
            if (previous?.draft.status != 'completed' &&
                next.draft.status == 'completed') {
              // Draft just completed, navigate to league details with Matchups tab
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LeagueDetailsScreen(
                        leagueId: widget.leagueId,
                        initialStep: 'Matchups',
                      ),
                    ),
                  );
                }
              });
            }
          },
        );

        // Now watch the matchup draft room state
        final draftRoomState = ref.watch(
          matchupDraftRoomProvider((
            leagueId: widget.leagueId,
            draftId: widget.draftId,
            draft: draft,
          )),
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('MATCHUP Draft'),
            actions: [
              // Connection status indicator
              if (!draftRoomState.isConnected)
                const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.cloud_off, color: Colors.red),
                ),

              // Commissioner controls
              MatchupDraftCommissionerControls(
                leagueId: widget.leagueId,
                draftId: widget.draftId,
                draft: draft,
                draftStatus: draftRoomState.draft.status,
              ),
            ],
          ),
          body: Stack(
            children: [
              // Main content: Matchup draft board (always visible, full screen)
              MatchupDraftBoardPanel(
                leagueId: widget.leagueId,
                draftId: widget.draftId,
                draft: draft,
              ),
              // Overlay: Matchup selection panel (bottom-left)
              MatchupSelectionPanel(
                leagueId: widget.leagueId,
                draftId: widget.draftId,
                draft: draft,
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text('Error loading matchup draft: $error'),
        ),
      ),
    );
  }
}
