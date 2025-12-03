import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/league.dart';
import '../../matchup_drafts/application/matchup_drafts_provider.dart';
import '../../matchup_drafts/domain/matchup_draft_pick.dart';
import '../../../../shared/widgets/cards/section_card.dart';

/// Card showing matchups overview with week toggle when matchups are generated
class MatchupsOverviewCard extends ConsumerStatefulWidget {
  final League league;

  const MatchupsOverviewCard({
    super.key,
    required this.league,
  });

  @override
  ConsumerState<MatchupsOverviewCard> createState() => _MatchupsOverviewCardState();
}

class _MatchupsOverviewCardState extends ConsumerState<MatchupsOverviewCard> {
  int? _selectedWeek;

  @override
  Widget build(BuildContext context) {
    final matchupsType = widget.league.settings?['matchups_type']?.toString() ?? 'randomize';
    final matchupDraftOrder = widget.league.settings?['matchup_draft_order']?.toString() ?? 'randomize';
    final isRandomize = matchupsType.toLowerCase() == 'randomize';
    final isDraftMode = matchupsType.toLowerCase() == 'draft';
    final showRandomizeButton = isDraftMode && matchupDraftOrder.toLowerCase() == 'randomize';

    final matchupDraftAsync = ref.watch(matchupDraftProvider(widget.league.id));

    return SectionCard(
      title: 'Matchups',
      child: matchupDraftAsync.when(
        data: (draft) {
          // If draft is completed, show matchups
          if (draft.status == 'completed') {
            return _buildCompletedMatchupsView(context, draft.id);
          }

          // Otherwise show the generate/draft UI
          return _buildGenerateMatchupsView(
            context,
            isRandomize: isRandomize,
            showRandomizeButton: showRandomizeButton,
          );
        },
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stack) => _buildGenerateMatchupsView(
          context,
          isRandomize: isRandomize,
          showRandomizeButton: showRandomizeButton,
        ),
      ),
    );
  }

  Widget _buildCompletedMatchupsView(BuildContext context, int draftId) {
    final picksAsync = ref.watch(
      matchupDraftPicksProvider((leagueId: widget.league.id, draftId: draftId)),
    );

    return picksAsync.when(
      data: (picks) {
        if (picks.isEmpty) {
          return _buildEmptyMatchupsView(context);
        }

        // Group picks by week
        final picksByWeek = <int, List<MatchupDraftPick>>{};
        for (final pick in picks) {
          picksByWeek.putIfAbsent(pick.weekNumber, () => []).add(pick);
        }

        final weeks = picksByWeek.keys.toList()..sort();

        // Initialize selected week if not set
        if (_selectedWeek == null || !weeks.contains(_selectedWeek)) {
          _selectedWeek = weeks.first;
        }

        final currentWeekPicks = picksByWeek[_selectedWeek] ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Week selector chips
            _buildWeekSelector(context, weeks),
            const SizedBox(height: 16),
            // Matchups for selected week
            _buildMatchupsList(context, currentWeekPicks),
            const SizedBox(height: 16),
            // Re-generate button for commissioner
            if (widget.league.isCommissioner)
              Center(
                child: OutlinedButton.icon(
                  onPressed: () => _regenerateMatchups(context),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Re-generate Matchups'),
                ),
              ),
          ],
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Error loading matchups: $error'),
        ),
      ),
    );
  }

  Widget _buildWeekSelector(BuildContext context, List<int> weeks) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: weeks.map((week) {
          final isSelected = week == _selectedWeek;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text('Week $week'),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedWeek = week);
                }
              },
              selectedColor: Theme.of(context).colorScheme.primaryContainer,
              labelStyle: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMatchupsList(BuildContext context, List<MatchupDraftPick> picks) {
    // Group picks into matchups (each matchup has 2 entries - one for each team)
    // For now, we just display each pick as "Team X vs Opponent"
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: picks.map((pick) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      pick.pickerUsername ?? 'Team ${pick.pickerRosterNumber ?? pick.rosterId}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'vs',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      pick.opponentUsername ?? 'Team ${pick.opponentRosterNumber}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyMatchupsView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          'No matchups generated yet',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildGenerateMatchupsView(
    BuildContext context, {
    required bool isRandomize,
    required bool showRandomizeButton,
  }) {
    return Container(
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
            if (isRandomize && !widget.league.isCommissioner) ...[
              Text(
                'Only the commissioner can generate matchups',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],
            FilledButton.icon(
              onPressed: isRandomize
                  ? (widget.league.isCommissioner
                      ? () => _generateRandomMatchups(context)
                      : null)
                  : () => _navigateToMatchupDraft(context),
              icon: Icon(isRandomize ? Icons.shuffle : Icons.dynamic_feed),
              label: Text(isRandomize ? 'Generate Matchups' : 'Matchups Draft'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateRandomMatchups(BuildContext context) async {
    try {
      final apiClient = ref.read(matchupDraftsApiClientProvider);
      final result = await apiClient.generateRandomMatchups(widget.league.id);

      // Invalidate providers to refresh data
      ref.invalidate(matchupDraftProvider(widget.league.id));
      // Also invalidate picks provider if draft exists
      final draftId = result['draftId'] as int?;
      if (draftId != null) {
        ref.invalidate(matchupDraftPicksProvider((leagueId: widget.league.id, draftId: draftId)));
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Matchups generated successfully!'),
            backgroundColor: Theme.of(context).colorScheme.tertiary,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate matchups: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _regenerateMatchups(BuildContext context) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Re-generate Matchups?'),
        content: const Text(
          'This will delete all existing matchups and generate new random ones. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Re-generate'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await _generateRandomMatchups(context);
    }
  }

  Future<void> _navigateToMatchupDraft(BuildContext context) async {
    try {
      final matchupDraft = await ref.read(
        matchupDraftProvider(widget.league.id).future,
      );

      if (context.mounted) {
        context.go(
          '/league/${widget.league.id}/matchup-draft/${matchupDraft.id}/room',
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
  }

  Widget _buildDraftOrderSection(BuildContext context, WidgetRef ref) {
    final matchupDraftAsync = ref.watch(matchupDraftProvider(widget.league.id));

    return matchupDraftAsync.when(
      data: (matchupDraft) {
        final draftOrderAsync = ref.watch(
          matchupDraftOrderProvider((leagueId: widget.league.id, draftId: matchupDraft.id)),
        );

        return draftOrderAsync.when(
          data: (draftOrder) {
            if (draftOrder.isEmpty) {
              return OutlinedButton.icon(
                onPressed: () async {
                  try {
                    final apiClient = ref.read(matchupDraftsApiClientProvider);
                    await apiClient.randomizeMatchupDraftOrder(widget.league.id, matchupDraft.id);

                    ref.invalidate(matchupDraftProvider(widget.league.id));
                    ref.invalidate(matchupDraftOrderProvider((leagueId: widget.league.id, draftId: matchupDraft.id)));

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
                          await apiClient.randomizeMatchupDraftOrder(widget.league.id, matchupDraft.id);

                          ref.invalidate(matchupDraftProvider(widget.league.id));
                          ref.invalidate(matchupDraftOrderProvider((leagueId: widget.league.id, draftId: matchupDraft.id)));

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
                await apiClient.randomizeMatchupDraftOrder(widget.league.id, matchupDraft.id);

                ref.invalidate(matchupDraftProvider(widget.league.id));
                ref.invalidate(matchupDraftOrderProvider((leagueId: widget.league.id, draftId: matchupDraft.id)));

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
