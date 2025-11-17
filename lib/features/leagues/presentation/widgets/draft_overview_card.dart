import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/league.dart';
import '../../application/drafts_provider.dart';
import '../../../../config/app_config.dart';

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
  final Map<String, dynamic> draft;
  final int draftNumber;
  final int leagueId;

  const _DraftCard({
    required this.draft,
    required this.draftNumber,
    required this.leagueId,
  });

  @override
  ConsumerState<_DraftCard> createState() => _DraftCardState();
}

class _DraftCardState extends ConsumerState<_DraftCard> {
  bool _isExpanded = false;
  String? _expandedSection; // Track which section is expanded

  @override
  Widget build(BuildContext context) {
    final draftType = widget.draft['draft_type'] as String? ?? 'snake';
    final rounds = widget.draft['rounds'] as int? ?? 15;
    final settings = widget.draft['settings'] as Map<String, dynamic>? ?? {};
    final playerPool = settings['player_pool'] as String? ?? 'all';
    final draftId = widget.draft['id'] as int;

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
    final settings = widget.draft['settings'] as Map<String, dynamic>? ?? {};
    final draftOrder = settings['draft_order'] as String? ?? 'randomize';
    final draftId = widget.draft['id'] as int;

    // Parse derby start time if present
    final derbyStartTimeStr = settings['derby_start_time'] as String?;
    final derbyStartTime = derbyStartTimeStr != null ? DateTime.tryParse(derbyStartTimeStr) : null;

    // Watch the draft order provider
    final draftOrderState = ref.watch(draftOrderProvider((leagueId: widget.leagueId, draftId: draftId)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Derby countdown or notification (shown when derby order is selected)
        if (draftOrder.toLowerCase() == 'derby') ...[
          if (derbyStartTime != null)
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
                        _DerbyCountdown(targetTime: derbyStartTime),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
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

        // Randomize button
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
        // Draft order list
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

            return Column(
              children: order.map((item) {
                final position = item['draft_position'] as int;
                final username = item['username'] as String? ?? 'Unknown';

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

/// Derby countdown widget - shows time remaining until derby start
class _DerbyCountdown extends StatefulWidget {
  final DateTime targetTime;

  const _DerbyCountdown({required this.targetTime});

  @override
  State<_DerbyCountdown> createState() => _DerbyCountdownState();
}

class _DerbyCountdownState extends State<_DerbyCountdown> {
  late Duration _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        _updateRemaining();
      }
    });
  }

  @override
  void didUpdateWidget(_DerbyCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.targetTime != oldWidget.targetTime) {
      _updateRemaining();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateRemaining() {
    setState(() {
      _remaining = widget.targetTime.difference(DateTime.now());
    });
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) {
      return 'Started ${_formatPositiveDuration(duration.abs())} ago';
    }
    return _formatPositiveDuration(duration);
  }

  String _formatPositiveDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (days > 0) {
      return '$days day${days != 1 ? 's' : ''}, ${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  Color _getTextColor() {
    if (_remaining.isNegative) {
      return Colors.red;
    } else if (_remaining.inHours < 1) {
      return Colors.orange;
    } else {
      return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDuration(_remaining),
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: _getTextColor(),
      ),
    );
  }
}
