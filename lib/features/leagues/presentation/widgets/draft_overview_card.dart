import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/league.dart';
import '../../domain/draft.dart';
import '../../application/drafts_provider.dart';
import '../../../auth/application/auth_notifier.dart';
import 'derby/derby_countdown_widget.dart';

/// Card showing draft overview with draft details
class DraftOverviewCard extends ConsumerWidget {
  final League league;

  const DraftOverviewCard({
    super.key,
    required this.league,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftsAsync = ref.watch(leagueDraftsProvider(league.id));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Draft',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            draftsAsync.when(
              data: (drafts) {
                if (drafts.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        'No drafts configured',
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  );
                }

                // Show all drafts as collapsible cards
                return Column(
                  children: drafts.asMap().entries.map((entry) {
                    final index = entry.key;
                    final draft = entry.value;

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < drafts.length - 1 ? 16 : 0,
                      ),
                      child: _DraftCard(
                        draft: draft,
                        draftNumber: index + 1,
                        leagueId: league.id,
                        isCommissioner: league.isCommissioner,
                        league: league,
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Error loading draft info: $error',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual draft card with collapsible sections
class _DraftCard extends ConsumerStatefulWidget {
  final Draft draft;
  final int draftNumber;
  final int leagueId;
  final bool isCommissioner;
  final League league;

  const _DraftCard({
    required this.draft,
    required this.draftNumber,
    required this.leagueId,
    required this.isCommissioner,
    required this.league,
  });

  @override
  ConsumerState<_DraftCard> createState() => _DraftCardState();
}

class _DraftCardState extends ConsumerState<_DraftCard> {
  bool _isExpanded = false;
  String? _expandedSection; // Track which section is expanded

  @override
  Widget build(BuildContext context) {
    final draftType = widget.draft.draftType;
    final rounds = widget.draft.rounds;
    final settings = widget.draft.settings;
    final playerPool = settings?.playerPool ?? 'all';

    return Card(
      elevation: 2,
      child: Column(
        children: [
          // Header - always visible
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Draft ${widget.draftNumber}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Summary info
                        Row(
                          children: [
                            _SummaryChip(
                              label: _formatDraftType(draftType),
                              icon: Icons.swap_vert,
                            ),
                            const SizedBox(width: 8),
                            _SummaryChip(
                              label: '$rounds rounds',
                              icon: Icons.repeat,
                            ),
                            const SizedBox(width: 8),
                            _SummaryChip(
                              label: _formatPlayerPool(playerPool),
                              icon: Icons.people,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                ],
              ),
            ),
          ),

          // Expanded content - sections
          if (_isExpanded) ...[
            const Divider(height: 1),
            _buildDraftOrderSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildDraftOrderSection() {
    final isExpanded = _expandedSection == 'draft_order';

    return Column(
      children: [
        InkWell(
          onTap: () => setState(() {
            _expandedSection = isExpanded ? null : 'draft_order';
          }),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Draft Order',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) ...[
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildDraftOrderContent(),
          ),
        ],
      ],
    );
  }

  Widget _buildDraftOrderContent() {
    final settings = widget.draft.settings;
    final draftOrder = settings?.draftOrder ?? 'randomize';
    final draftId = widget.draft.id;

    // Parse derby times and status
    final derbyStartTime = settings?.derbyStartTime;
    final derbyStatus = settings?.derbyStatus;
    final pickDeadline = widget.draft.pickDeadline;

    // Watch the draft order provider
    final draftOrderState = ref.watch(draftOrderProvider((leagueId: widget.leagueId, draftId: draftId)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Derby countdown or notification (shown when derby order is selected)
        if (draftOrder.toLowerCase() == 'derby') ...[
          // If derby is in progress, show pick timer
          if (derbyStatus == 'in_progress' && pickDeadline != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Time to pick:',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSecondaryContainer,
                          ),
                        ),
                        const SizedBox(height: 4),
                        DerbyCountdownWidget(targetTime: pickDeadline),
                      ],
                    ),
                  ),
                ],
              ),
            )
          // If derby hasn't started yet, show start countdown
          else if (derbyStartTime != null && derbyStatus != 'completed')
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Derby starts in:',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 4),
                        DerbyCountdownWidget(targetTime: derbyStartTime),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else if (derbyStatus != 'completed' && derbyStatus != 'in_progress')
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.error.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Theme.of(context).colorScheme.error,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Derby start time not set',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],

        // Randomize/Start Derby button (only for commissioners)
        if (widget.isCommissioner && derbyStatus != 'in_progress') ...[
          draftOrderState.when(
            data: (order) {
              // Show "Start Derby" button if order is randomized and draft type is derby
              if (order.isNotEmpty && draftOrder.toLowerCase() == 'derby') {
                return Column(
                  children: [
                    FilledButton.icon(
                      onPressed: () async {
                        try {
                          await ref
                              .read(draftOrderProvider((leagueId: widget.leagueId, draftId: draftId)).notifier)
                              .startDerby();
                          // Refresh the drafts to get updated settings
                          ref.invalidate(leagueDraftsProvider(widget.leagueId));
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Derby started! Users can now select their draft positions.'),
                              ),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error starting derby: $e'),
                                backgroundColor: Theme.of(context).colorScheme.error,
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start Derby'),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }

              // Show "Randomize" button if order is not randomized or not derby
              return Column(
                children: [
                  FilledButton.icon(
                    onPressed: draftOrderState.isLoading
                        ? null
                        : () async {
                            try {
                              await ref
                                  .read(draftOrderProvider((leagueId: widget.leagueId, draftId: draftId)).notifier)
                                  .randomize();
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error randomizing draft order: $e'),
                                    backgroundColor: Theme.of(context).colorScheme.error,
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
          ),
        ],
        // Draft order list or slot selection
        draftOrderState.when(
          data: (order) {
            if (order.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Click the button above to randomize draft order',
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              );
            }

            // If derby is in progress or paused, show slot selection UI
            if ((derbyStatus == 'in_progress' || derbyStatus == 'paused') && draftOrder.toLowerCase() == 'derby') {
              final currentPickerIndex = settings?.currentPickerIndex ?? 0;
              final currentPicker = order[currentPickerIndex];
              final currentPickerUserId = currentPicker['user_id'] as int?;

              // Get current user's ID to check if it's their turn
              final authState = ref.watch(authProvider);
              final currentUserId = authState.user != null ? int.tryParse(authState.user!.userId) : null;
              final isMyTurn = currentUserId != null && currentPickerUserId == currentUserId;

              // Create a map of taken positions
              // Only include positions from users who have already picked (before current picker)
              final takenPositions = <int, Map<String, dynamic>>{};
              for (int i = 0; i < currentPickerIndex; i++) {
                final item = order[i];
                final position = item['draft_position'] as int;
                takenPositions[position] = item;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Derby pick order
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Derby Pick Order',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...order.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          final username = item['username'] as String? ?? 'Team ${item['roster_number']}';
                          final isCurrent = index == currentPickerIndex;
                          final hasPicked = index < currentPickerIndex;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: isCurrent
                                        ? Theme.of(context).colorScheme.primary
                                        : hasPicked
                                            ? Theme.of(context).colorScheme.primaryContainer
                                            : Theme.of(context).colorScheme.surfaceContainer,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: isCurrent
                                            ? Theme.of(context).colorScheme.onPrimary
                                            : hasPicked
                                                ? Theme.of(context).colorScheme.onPrimaryContainer
                                                : Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    username,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                                      color: isCurrent
                                          ? Theme.of(context).colorScheme.primary
                                          : Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                                if (hasPicked)
                                  Icon(
                                    Icons.check_circle,
                                    size: 16,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),

                  // Current picker info
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: isMyTurn
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isMyTurn ? Icons.touch_app : Icons.person,
                          size: 20,
                          color: isMyTurn
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            isMyTurn
                                ? 'Your turn to pick a slot!'
                                : 'Waiting for ${currentPicker['username'] ?? 'player'} to pick...',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isMyTurn
                                  ? Theme.of(context).colorScheme.onPrimaryContainer
                                  : Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Commissioner pause/resume button
                  if (widget.isCommissioner) ...[
                    OutlinedButton.icon(
                      onPressed: () async {
                        try {
                          if (derbyStatus == 'in_progress') {
                            // Pause the derby
                            await ref
                                .read(draftOrderProvider((leagueId: widget.leagueId, draftId: draftId)).notifier)
                                .pauseDerby();
                          } else if (derbyStatus == 'paused') {
                            // Resume the derby
                            await ref
                                .read(draftOrderProvider((leagueId: widget.leagueId, draftId: draftId)).notifier)
                                .resumeDerby();
                          }
                          // Refresh the drafts to get updated settings
                          ref.invalidate(leagueDraftsProvider(widget.leagueId));
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Theme.of(context).colorScheme.error,
                              ),
                            );
                          }
                        }
                      },
                      icon: Icon(derbyStatus == 'paused' ? Icons.play_arrow : Icons.pause),
                      label: Text(derbyStatus == 'paused' ? 'Resume Derby' : 'Pause Derby'),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Slot selection grid
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(order.length, (index) {
                      final slotNumber = index + 1;
                      final slotData = takenPositions[slotNumber];
                      final isTaken = slotData != null && slotData['username'] != null;

                      return SizedBox(
                        width: (MediaQuery.of(context).size.width - 80) / 4, // 4 columns
                        child: OutlinedButton(
                          onPressed: (!isTaken && isMyTurn && derbyStatus == 'in_progress')
                              ? () async {
                                  try {
                                    await ref
                                        .read(draftOrderProvider((leagueId: widget.leagueId, draftId: draftId)).notifier)
                                        .pickSlot(slotNumber);
                                    // Refresh the drafts to get updated settings
                                    ref.invalidate(leagueDraftsProvider(widget.leagueId));
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Error picking slot: $e'),
                                          backgroundColor: Theme.of(context).colorScheme.error,
                                        ),
                                      );
                                    }
                                  }
                                }
                              : null,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: isTaken
                                ? Theme.of(context).colorScheme.surfaceContainerHighest
                                : (isMyTurn ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3) : null),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Slot $slotNumber',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: isTaken
                                      ? Theme.of(context).colorScheme.onSurfaceVariant
                                      : (isMyTurn ? Theme.of(context).colorScheme.primary : null),
                                ),
                              ),
                              if (isTaken) ...[
                                const SizedBox(height: 4),
                                Text(
                                  slotData['username'] ?? 'Taken',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            }

            // Normal draft order display
            return Column(
              children: order.map((item) {
                final position = item['draft_position'] as int;
                final username = item['username'] as String? ?? 'Team ${item['roster_number']}';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$position',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          username,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Error loading draft order: $error',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDraftType(String type) {
    switch (type.toLowerCase()) {
      case 'snake':
        return 'Snake';
      case 'linear':
        return 'Linear';
      default:
        return type;
    }
  }

  String _formatPlayerPool(String pool) {
    switch (pool.toLowerCase()) {
      case 'all':
        return 'All';
      case 'rookie':
        return 'Rookie';
      case 'vet':
        return 'Vet';
      default:
        return pool;
    }
  }
}

/// Small chip for summary information
class _SummaryChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _SummaryChip({
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

