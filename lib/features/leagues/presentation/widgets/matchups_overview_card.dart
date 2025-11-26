import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/league.dart';
import '../../matchup_drafts/application/matchup_drafts_provider.dart';
import '../../../../shared/widgets/cards/section_card.dart';

/// Card showing matchups overview (placeholder)
class MatchupsOverviewCard extends ConsumerWidget {
  final League league;

  const MatchupsOverviewCard({
    super.key,
    required this.league,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchupsType = league.settings?['matchups_type']?.toString() ?? 'randomize';
    final matchupDraftOrder = league.settings?['matchup_draft_order']?.toString() ?? 'randomize';
    final isRandomize = matchupsType.toLowerCase() == 'randomize';
    final isDraftMode = matchupsType.toLowerCase() == 'draft';
    final showRandomizeButton = isDraftMode && matchupDraftOrder.toLowerCase() == 'randomize';

    return SectionCard(
      title: 'Matchups',
      child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.sports_football,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isRandomize
                          ? 'Ready to generate matchups'
                          : 'Ready to draft matchups',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isRandomize
                          ? 'Generate matchups to determine weekly opponents'
                          : 'Draft matchups to let teams choose their opponents',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    if (showRandomizeButton) ...[
                      _buildDraftOrderSection(context, ref),
                      const SizedBox(height: 12),
                    ],
                    FilledButton.icon(
                      onPressed: isRandomize
                          ? () {
                              // TODO: Implement matchups generation
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Matchups generation coming soon'),
                                ),
                              );
                            }
                          : () async {
                              // Navigate to matchup draft room
                              try {
                                // Get or create matchup draft
                                final matchupDraft = await ref.read(
                                  matchupDraftProvider(league.id).future,
                                );

                                if (context.mounted) {
                                  context.go(
                                    '/league/${league.id}/matchup-draft/${matchupDraft.id}/room',
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to load matchup draft: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                      icon: Icon(isRandomize ? Icons.shuffle : Icons.dynamic_feed),
                      label: Text(isRandomize ? 'Generate Matchups' : 'Matchups Draft'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDraftOrderSection(BuildContext context, WidgetRef ref) {
    final matchupDraftAsync = ref.watch(matchupDraftProvider(league.id));

    return matchupDraftAsync.when(
      data: (matchupDraft) {
        final draftOrderAsync = ref.watch(
          matchupDraftOrderProvider((leagueId: league.id, draftId: matchupDraft.id)),
        );

        return draftOrderAsync.when(
          data: (draftOrder) {
            if (draftOrder.isEmpty) {
              // Show randomize button if no order exists
              return OutlinedButton.icon(
                onPressed: () async {
                  try {
                    final apiClient = ref.read(matchupDraftsApiClientProvider);
                    await apiClient.randomizeMatchupDraftOrder(league.id, matchupDraft.id);

                    // Invalidate providers to refresh data
                    ref.invalidate(matchupDraftProvider(league.id));
                    ref.invalidate(matchupDraftOrderProvider((leagueId: league.id, draftId: matchupDraft.id)));

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Matchup draft order randomized successfully!'),
                          backgroundColor: Theme.of(context).colorScheme.tertiary,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to randomize draft order: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.shuffle),
                label: const Text('Randomize Draft Order'),
              );
            }

            // Show the draft order
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Draft Order',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () async {
                        try {
                          final apiClient = ref.read(matchupDraftsApiClientProvider);
                          await apiClient.randomizeMatchupDraftOrder(league.id, matchupDraft.id);

                          ref.invalidate(matchupDraftProvider(league.id));
                          ref.invalidate(matchupDraftOrderProvider((leagueId: league.id, draftId: matchupDraft.id)));

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Draft order re-randomized!'),
                                backgroundColor: Theme.of(context).colorScheme.tertiary,
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to randomize: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.shuffle, size: 16),
                      label: const Text('Re-randomize', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        minimumSize: const Size(0, 0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...draftOrder.asMap().entries.map((entry) {
                  final index = entry.key;
                  final orderEntry = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          orderEntry.username ?? 'Team ${orderEntry.rosterId}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => OutlinedButton.icon(
            onPressed: () async {
              try {
                final apiClient = ref.read(matchupDraftsApiClientProvider);
                await apiClient.randomizeMatchupDraftOrder(league.id, matchupDraft.id);

                ref.invalidate(matchupDraftProvider(league.id));
                ref.invalidate(matchupDraftOrderProvider((leagueId: league.id, draftId: matchupDraft.id)));

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Matchup draft order randomized successfully!'),
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to randomize draft order: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            icon: const Icon(Icons.shuffle),
            label: const Text('Randomize Draft Order'),
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
