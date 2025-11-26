import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/matchup_drafts_provider.dart';
import '../../../drafts/domain/draft.dart';

/// Commissioner controls for matchup draft (Start/Pause/Resume)
class MatchupDraftCommissionerControls extends ConsumerWidget {
  final int leagueId;
  final int draftId;
  final Draft draft;
  final String draftStatus;

  const MatchupDraftCommissionerControls({
    super.key,
    required this.leagueId,
    required this.draftId,
    required this.draft,
    required this.draftStatus,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!draft.isCommissioner) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Start Draft button (only when not started)
        if (draftStatus == 'not_started')
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                final notifier = ref.read(
                  matchupDraftRoomProvider((
                    leagueId: leagueId,
                    draftId: draftId,
                    draft: draft,
                  )).notifier,
                );

                try {
                  await notifier.startDraft();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Matchup draft started!'),
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
        if (draftStatus == 'in_progress' || draftStatus == 'paused')
          IconButton(
            icon: Icon(
              draftStatus == 'paused' ? Icons.play_arrow : Icons.pause,
            ),
            onPressed: () async {
              final notifier = ref.read(
                matchupDraftRoomProvider((
                  leagueId: leagueId,
                  draftId: draftId,
                  draft: draft,
                )).notifier,
              );

              if (draftStatus == 'paused') {
                await notifier.resumeDraft();
              } else {
                await notifier.pauseDraft();
              }
            },
          ),
      ],
    );
  }
}
