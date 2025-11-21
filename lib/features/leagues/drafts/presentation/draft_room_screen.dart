import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/draft_room_provider.dart';
import '../application/drafts_provider.dart';
import 'widgets/draft_board_panel.dart';
import 'widgets/collapsible_draft_panel.dart';

class DraftRoomScreen extends ConsumerStatefulWidget {
  final int leagueId;
  final int draftId;

  const DraftRoomScreen({
    super.key,
    required this.leagueId,
    required this.draftId,
  });

  @override
  ConsumerState<DraftRoomScreen> createState() => _DraftRoomScreenState();
}

class _DraftRoomScreenState extends ConsumerState<DraftRoomScreen> {
  @override
  Widget build(BuildContext context) {
    // First, get the draft to pass to the provider
    final draftsAsync = ref.watch(leagueDraftsProvider(widget.leagueId));

    return draftsAsync.when(
      data: (drafts) {
        final draft = drafts.firstWhere((d) => d.id == widget.draftId);

        // Now watch the draft room state
        final draftRoomState = ref.watch(
          draftRoomProvider((
            leagueId: widget.leagueId,
            draftId: widget.draftId,
            draft: draft,
          )),
        );

        return Scaffold(
          appBar: AppBar(
            title: Text('${draft.draftType.toUpperCase()} Draft'),
            actions: [
              // Connection status indicator
              if (!draftRoomState.isConnected)
                const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.cloud_off, color: Colors.red),
                ),

              // Commissioner controls
              if (draft.isCommissioner) ...[
                IconButton(
                  icon: Icon(
                    draftRoomState.draft.status == 'paused'
                        ? Icons.play_arrow
                        : Icons.pause,
                  ),
                  onPressed: () async {
                    final notifier = ref.read(
                      draftRoomProvider((
                        leagueId: widget.leagueId,
                        draftId: widget.draftId,
                        draft: draft,
                      )).notifier,
                    );

                    if (draftRoomState.draft.status == 'paused') {
                      await notifier.resumeDraft();
                    } else {
                      await notifier.pauseDraft();
                    }
                  },
                ),
              ],
            ],
          ),
          body: Stack(
            children: [
              // Main content: Draft board (always visible, full screen)
              DraftBoardPanel(
                leagueId: widget.leagueId,
                draftId: widget.draftId,
                draft: draft,
              ),
              // Overlay: Collapsible draft panel (bottom-left)
              CollapsibleDraftPanel(
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
          child: Text('Error loading draft: $error'),
        ),
      ),
    );
  }
}
