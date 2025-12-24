import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/league.dart';
import '../../drafts/application/drafts_provider.dart';
import '../../live_scores/application/live_score_provider.dart';
import '../../matchup_drafts/application/matchup_drafts_provider.dart';
import '../../matchup_drafts/domain/matchup_draft_pick.dart';
import '../../../../shared/widgets/cards/section_card.dart';
import 'matchup_detail_dialog.dart';

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
  final ScrollController _weekScrollController = ScrollController();
  bool _hasScrolledToWeek = false;
  // Track which matchup is expanded (by rosterId)
  int? _expandedMatchupRosterId;

  @override
  void dispose() {
    _weekScrollController.dispose();
    super.dispose();
  }

  /// Estimate current NFL week based on date
  int _estimateCurrentWeek() {
    final now = DateTime.now();
    final currentYear = now.year;
    final leagueSeason = int.tryParse(widget.league.season) ?? currentYear;

    // NFL season start dates (first Thursday of September)
    final seasonStartDates = <int, DateTime>{
      2024: DateTime(2024, 9, 5),
      2025: DateTime(2025, 9, 4),
      2026: DateTime(2026, 9, 10),
    };

    DateTime seasonStart;
    if (seasonStartDates.containsKey(leagueSeason)) {
      seasonStart = seasonStartDates[leagueSeason]!;
    } else {
      // Calculate first Thursday of September for the league season
      final sept1 = DateTime(leagueSeason, 9, 1);
      final dayOfWeek = sept1.weekday; // 1=Mon, 7=Sun
      final daysUntilThursday = (4 - dayOfWeek + 7) % 7;
      seasonStart = DateTime(leagueSeason, 9, 1 + daysUntilThursday);
    }

    // If now is before the season start, default to week 1
    if (now.isBefore(seasonStart)) {
      return 1;
    }

    final weeksSinceStart = now.difference(seasonStart).inDays ~/ 7;
    final week = weeksSinceStart + 1;

    // Clamp to valid range (1-18)
    if (week < 1) return 1;
    if (week > 18) return 18;
    return week;
  }

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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      spacing: 8,
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

        // Initialize selected week if not set - default to current NFL week
        if (_selectedWeek == null || !weeks.contains(_selectedWeek)) {
          final currentWeek = _estimateCurrentWeek();
          // Find the closest available week to the current week
          if (weeks.contains(currentWeek)) {
            _selectedWeek = currentWeek;
          } else {
            // Find closest week (prefer the week just before current)
            final closestWeek = weeks.lastWhere(
              (w) => w <= currentWeek,
              orElse: () => weeks.first,
            );
            _selectedWeek = closestWeek;
          }
        }

        final currentWeekPicks = picksByWeek[_selectedWeek] ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Week selector chips
            _buildWeekSelector(context, weeks),
            const SizedBox(height: 16),
            // Matchups for selected week (with stats)
            _buildMatchupsListWithStats(context, currentWeekPicks, draftId),
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
    // Auto-scroll to selected week after first build
    if (!_hasScrolledToWeek && _selectedWeek != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_weekScrollController.hasClients) {
          final selectedIndex = weeks.indexOf(_selectedWeek!);
          if (selectedIndex > 0) {
            // Estimate chip width (~80px per chip including padding)
            const chipWidth = 88.0;
            final scrollOffset = (selectedIndex * chipWidth) - 40; // Center a bit
            _weekScrollController.animateTo(
              scrollOffset.clamp(0.0, _weekScrollController.position.maxScrollExtent),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
          _hasScrolledToWeek = true;
        }
      });
    }

    return SingleChildScrollView(
      controller: _weekScrollController,
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

  Widget _buildMatchupsListWithStats(
    BuildContext context,
    List<MatchupDraftPick> picks,
    int draftId,
  ) {
    // Fetch draft picks with stats for calculating team totals
    final draftsAsync = ref.watch(leagueDraftsProvider(widget.league.id));

    return draftsAsync.when(
      data: (drafts) {
        if (drafts.isEmpty) {
          return _buildMatchupsListSimple(context, picks);
        }

        final completedDraft = drafts.firstWhere(
          (d) => d.status == 'completed',
          orElse: () => drafts.first,
        );

        final statsAsync = ref.watch(leagueDraftPicksWithStatsProvider((
          leagueId: widget.league.id,
          draftId: completedDraft.id,
          week: _selectedWeek!,
        )));

        return statsAsync.when(
          data: (draftPicks) {
            // Calculate totals per roster (only starters count toward team total)
            final teamTotals = <int, ({double projected, double actual})>{};
            for (final pick in draftPicks) {
              // Only include starters in the team totals
              if (pick.isStarter != true) continue;

              final rosterId = pick.rosterId;
              final current = teamTotals[rosterId] ?? (projected: 0.0, actual: 0.0);
              teamTotals[rosterId] = (
                projected: current.projected + (pick.projectedPts ?? 0),
                actual: current.actual + (pick.actualPts ?? 0),
              );
            }

            return _buildMatchupsListWithTotals(context, picks, teamTotals);
          },
          loading: () => _buildMatchupsListSimple(context, picks),
          error: (_, __) => _buildMatchupsListSimple(context, picks),
        );
      },
      loading: () => _buildMatchupsListSimple(context, picks),
      error: (_, __) => _buildMatchupsListSimple(context, picks),
    );
  }

  Widget _buildMatchupsListSimple(BuildContext context, List<MatchupDraftPick> picks) {
    return _buildMatchupsListWithTotals(context, picks, {});
  }

  Widget _buildMatchupsListWithTotals(
    BuildContext context,
    List<MatchupDraftPick> picks,
    Map<int, ({double projected, double actual})> teamTotals,
  ) {
    // Watch live score provider for real-time updates
    final liveScores = ref.watch(liveScoreProvider(widget.league.id));
    // Only use live data when viewing the current NFL week
    final currentWeek = _estimateCurrentWeek();
    final isCurrentWeek = _selectedWeek == currentWeek;
    final hasLiveData = liveScores.playerStats.isNotEmpty && isCurrentWeek;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: picks.map((pick) {
          // Use live data if available, otherwise fall back to static data
          double? team1Projected;
          double? team1Actual;
          double? team2Projected;
          double? team2Actual;

          if (hasLiveData) {
            // Use pace projections from live data
            team1Projected = liveScores.getRosterPaceProjection(pick.rosterId);
            team1Actual = liveScores.getRosterActualPoints(pick.rosterId);
            team2Projected = liveScores.getRosterPaceProjection(pick.opponentRosterId);
            team2Actual = liveScores.getRosterActualPoints(pick.opponentRosterId);
          } else {
            // Fall back to static data
            final t1 = teamTotals[pick.rosterId];
            final t2 = teamTotals[pick.opponentRosterId];
            team1Projected = t1?.projected;
            team1Actual = t1?.actual;
            team2Projected = t2?.projected;
            team2Actual = t2?.actual;
          }

          final isExpanded = _expandedMatchupRosterId == pick.rosterId;

          return Column(
            children: [
              // Matchup summary row (clickable header)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _expandedMatchupRosterId = isExpanded ? null : pick.rosterId;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildTeamWithScore(
                            context,
                            pick.pickerUsername ?? 'Team ${pick.pickerRosterNumber ?? pick.rosterId}',
                            team1Projected,
                            team1Actual,
                            Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
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
                          child: _buildTeamWithScore(
                            context,
                            pick.opponentUsername ?? 'Team ${pick.opponentRosterNumber}',
                            team2Projected,
                            team2Actual,
                            Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.5),
                          ),
                        ),
                        const SizedBox(width: 8),
                        AnimatedRotation(
                          turns: isExpanded ? 0.25 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.chevron_right,
                            size: 20,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Expanded detail content
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: MatchupDetailContent(
                  leagueId: widget.league.id,
                  matchup: pick,
                  onCollapse: () {
                    setState(() {
                      _expandedMatchupRosterId = null;
                    });
                  },
                ),
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
              // Divider between matchups (except last)
              if (pick != picks.last)
                Divider(
                  height: 1,
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTeamWithScore(
    BuildContext context,
    String teamName,
    double? projectedPts,
    double? actualPts,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            teamName,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (projectedPts != null || actualPts != null) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Projected points (Caveat font, muted)
                Text(
                  projectedPts?.toStringAsFixed(1) ?? '-',
                  style: GoogleFonts.caveat(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                const SizedBox(width: 8),
                // Actual points (Orbitron font, primary)
                Text(
                  actualPts?.toStringAsFixed(1) ?? '-',
                  style: GoogleFonts.orbitron(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ],
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
