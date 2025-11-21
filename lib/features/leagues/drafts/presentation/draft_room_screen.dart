import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/draft_room_provider.dart';
import '../application/drafts_provider.dart';
import 'widgets/player_selection_panel.dart';
import 'widgets/draft_board_panel.dart';

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
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 1200;
              final isMedium = constraints.maxWidth > 600;

              if (isWide) {
                // Desktop: 3-panel layout
                return Row(
                  children: [
                    // Left panel: Player selection
                    Expanded(
                      flex: 2,
                      child: PlayerSelectionPanel(
                        leagueId: widget.leagueId,
                        draftId: widget.draftId,
                        draft: draft,
                      ),
                    ),
                    const VerticalDivider(width: 1),
                    // Center panel: Draft board
                    Expanded(
                      flex: 3,
                      child: DraftBoardPanel(
                        leagueId: widget.leagueId,
                        draftId: widget.draftId,
                        draft: draft,
                      ),
                    ),
                    const VerticalDivider(width: 1),
                    // Right panel: Activity feed
                    Expanded(
                      flex: 2,
                      child: _ActivityFeedPanel(
                        leagueId: widget.leagueId,
                        draftId: widget.draftId,
                        draft: draft,
                      ),
                    ),
                  ],
                );
              } else if (isMedium) {
                // Tablet: 2-panel with drawer
                return Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: PlayerSelectionPanel(
                        leagueId: widget.leagueId,
                        draftId: widget.draftId,
                        draft: draft,
                      ),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(
                      flex: 3,
                      child: DraftBoardPanel(
                        leagueId: widget.leagueId,
                        draftId: widget.draftId,
                        draft: draft,
                      ),
                    ),
                  ],
                );
              } else {
                // Mobile: Single panel with tabs
                return _MobileDraftView(
                  leagueId: widget.leagueId,
                  draftId: widget.draftId,
                  draft: draft,
                );
              }
            },
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

// Placeholder widgets - will implement these next
class _ActivityFeedPanel extends ConsumerWidget {
  final int leagueId;
  final int draftId;
  final dynamic draft;

  const _ActivityFeedPanel({
    required this.leagueId,
    required this.draftId,
    required this.draft,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: const Center(
        child: Text('Activity Feed Panel'),
      ),
    );
  }
}

class _MobileDraftView extends ConsumerStatefulWidget {
  final int leagueId;
  final int draftId;
  final dynamic draft;

  const _MobileDraftView({
    required this.leagueId,
    required this.draftId,
    required this.draft,
  });

  @override
  ConsumerState<_MobileDraftView> createState() => _MobileDraftViewState();
}

class _MobileDraftViewState extends ConsumerState<_MobileDraftView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Players', icon: Icon(Icons.people)),
            Tab(text: 'Board', icon: Icon(Icons.grid_on)),
            Tab(text: 'Activity', icon: Icon(Icons.history)),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              PlayerSelectionPanel(
                leagueId: widget.leagueId,
                draftId: widget.draftId,
                draft: widget.draft,
              ),
              DraftBoardPanel(
                leagueId: widget.leagueId,
                draftId: widget.draftId,
                draft: widget.draft,
              ),
              _ActivityFeedPanel(
                leagueId: widget.leagueId,
                draftId: widget.draftId,
                draft: widget.draft,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
