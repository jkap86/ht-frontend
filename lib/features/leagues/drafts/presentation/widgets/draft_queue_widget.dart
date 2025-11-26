import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/queue_provider.dart';
import '../../../../players/domain/player.dart';

/// Widget displaying the user's draft queue with drag-to-reorder functionality
class DraftQueueWidget extends ConsumerWidget {
  final int leagueId;
  final int draftId;

  const DraftQueueWidget({
    super.key,
    required this.leagueId,
    required this.draftId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(queueProvider((
      leagueId: leagueId,
      draftId: draftId,
    )));

    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading queue',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.error!,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (state.items.isEmpty) {
      return Container(
        color: Theme.of(context).colorScheme.surface,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.queue_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'Your queue is empty',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add players to your queue to auto-pick them',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.5),
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final notifier = ref.read(queueProvider((
      leagueId: leagueId,
      draftId: draftId,
    )).notifier);

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: ReorderableListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: state.items.length,
        onReorder: (oldIndex, newIndex) {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          notifier.reorderQueue(oldIndex, newIndex);
        },
        itemBuilder: (context, index) {
          final queueEntry = state.items[index];
          final player = queueEntry.player;

          return Card(
            key: ValueKey(queueEntry.id),
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: ListTile(
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Icon(
                    Icons.drag_handle,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.4),
                  ),
                  const SizedBox(width: 8),
                  // Queue position
                  CircleAvatar(
                    radius: 16,
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                player?.fullName ?? 'Unknown Player',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              subtitle: player != null
                  ? Text(
                      '${player.position} - ${player.displayTeam}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                      ),
                    )
                  : null,
              trailing: IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => notifier.removeFromQueue(queueEntry.id),
                tooltip: 'Remove from queue',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          );
        },
      ),
    );
  }
}
