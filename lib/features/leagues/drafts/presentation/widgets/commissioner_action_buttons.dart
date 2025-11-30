import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/drafts_provider.dart';

/// Widget that displays commissioner-only action buttons for draft order management
class CommissionerActionButtons extends ConsumerWidget {
  final int leagueId;
  final int draftId;
  final bool isCommissioner;
  final String? derbyStatus;
  final String draftOrder;

  const CommissionerActionButtons({
    super.key,
    required this.leagueId,
    required this.draftId,
    required this.isCommissioner,
    required this.derbyStatus,
    required this.draftOrder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only show for commissioners when derby is not in progress or completed
    if (!isCommissioner ||
        derbyStatus == 'in_progress' ||
        derbyStatus == 'completed') {
      return const SizedBox.shrink();
    }

    final draftOrderState = ref.watch(
        draftOrderProvider((leagueId: leagueId, draftId: draftId)));

    return draftOrderState.when(
      data: (order) {
        // Show "Start Derby" button if order is randomized and draft type is derby
        if (order.isNotEmpty &&
            draftOrder.toLowerCase() == 'derby' &&
            derbyStatus != 'completed') {
          return Column(
            children: [
              // Re-randomize option for derby
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: draftOrderState.isLoading
                      ? null
                      : () async {
                          try {
                            await ref
                                .read(draftOrderProvider((
                                  leagueId: leagueId,
                                  draftId: draftId
                                )).notifier)
                                .randomize();
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Error randomizing draft order: $e'),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.error,
                                ),
                              );
                            }
                          }
                        },
                  icon: const Icon(Icons.shuffle, size: 16),
                  label: const Text('Re-randomize'),
                ),
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  try {
                    await ref
                        .read(draftOrderProvider((
                          leagueId: leagueId,
                          draftId: draftId
                        )).notifier)
                        .startDerby();
                    // Refresh the drafts to get updated settings
                    ref.invalidate(leagueDraftsProvider(leagueId));
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Derby started! Users can now select their draft positions.'),
                      ),
                    );
                  } catch (e) {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text('Error starting derby: $e'),
                        backgroundColor:
                            Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Derby'),
              ),
              const SizedBox(height: 16),
            ],
          );
        }

        // Show "Randomize" button if order is empty, or "Re-randomize" if already randomized
        final hasOrder = order.isNotEmpty;

        if (hasOrder) {
          // Show smaller "Re-randomize" button when order already exists
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: draftOrderState.isLoading
                    ? null
                    : () async {
                        try {
                          await ref
                              .read(draftOrderProvider((
                                leagueId: leagueId,
                                draftId: draftId
                              )).notifier)
                              .randomize();
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Error randomizing draft order: $e'),
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                              ),
                            );
                          }
                        }
                      },
                icon: const Icon(Icons.shuffle, size: 16),
                label: const Text('Re-randomize'),
              ),
            ),
          );
        }

        // Show full "Randomize" button when order is empty
        return Column(
          children: [
            FilledButton.icon(
              onPressed: draftOrderState.isLoading
                  ? null
                  : () async {
                      try {
                        await ref
                            .read(draftOrderProvider((
                              leagueId: leagueId,
                              draftId: draftId
                            )).notifier)
                            .randomize();
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Error randomizing draft order: $e'),
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                            ),
                          );
                        }
                      }
                    },
              icon: const Icon(Icons.shuffle),
              label: Text(
                draftOrder.toLowerCase() == 'derby'
                    ? 'Randomize Derby Order'
                    : 'Randomize Draft Order',
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
      loading: () => const Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
        ],
      ),
      error: (_, __) => Column(
        children: [
          FilledButton.icon(
            onPressed: null,
            icon: const Icon(Icons.shuffle),
            label: const Text('Randomize Draft Order'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
