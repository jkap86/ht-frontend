import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/draft_room_provider.dart';
import '../application/drafts_provider.dart';
import 'widgets/draft_board_panel.dart';
import 'widgets/collapsible_draft_panel.dart';
import '../../presentation/league_details_screen.dart';

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

        // Listen for draft completion and navigate to league details
        ref.listen(
          draftRoomProvider((
            leagueId: widget.leagueId,
            draftId: widget.draftId,
            draft: draft,
          )),
          (previous, next) {
            if (previous?.draft.status != 'completed' && next.draft.status == 'completed') {
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

              // Autopick toggle (available to all users once draft has started and state is loaded)
              if ((draftRoomState.draft.status == 'in_progress' ||
                      draftRoomState.draft.status == 'paused') &&
                  draftRoomState.draft.userRosterId != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    children: [
                      Text(
                        'Autopick',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Switch(
                        value: draftRoomState.isMyAutopickEnabled,
                        onChanged: (value) async {
                          final notifier = ref.read(
                            draftRoomProvider((
                              leagueId: widget.leagueId,
                              draftId: widget.draftId,
                              draft: draft,
                            )).notifier,
                          );

                          try {
                            await notifier.toggleAutopick();
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to toggle autopick: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),

              // Commissioner controls
              if (draft.isCommissioner) ...[
                // Start Draft button (only when not started)
                if (draftRoomState.draft.status == 'not_started')
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final notifier = ref.read(
                          draftRoomProvider((
                            leagueId: widget.leagueId,
                            draftId: widget.draftId,
                            draft: draft,
                          )).notifier,
                        );

                        try {
                          await notifier.startDraft();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Draft started!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to start draft: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start Draft'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                // Pause/Resume button (only when draft is active)
                if (draftRoomState.draft.status == 'in_progress' ||
                    draftRoomState.draft.status == 'paused')
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
