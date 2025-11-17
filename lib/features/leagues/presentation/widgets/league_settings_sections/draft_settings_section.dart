import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/league.dart';
import '../../../application/drafts_provider.dart';
import 'info_row.dart';

/// Read-only widget displaying draft settings
class DraftSettingsSection extends ConsumerWidget {
  final League league;

  const DraftSettingsSection({
    super.key,
    required this.league,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftsAsync = ref.watch(leagueDraftsProvider(league.id));

    return Card(
      child: ExpansionTile(
        initiallyExpanded: false,
        title: const Text(
          'Draft Settings',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: draftsAsync.when(
              data: (drafts) {
                if (drafts.isEmpty) {
                  return const Text(
                    'No drafts configured',
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  );
                }

                // Display all drafts
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: drafts.asMap().entries.map((entry) {
                    final index = entry.key;
                    final draft = entry.value;

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < drafts.length - 1 ? 16 : 0,
                      ),
                      child: _DraftInfo(
                        draftNumber: index + 1,
                        draft: draft,
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
              error: (error, stack) => Text(
                'Error loading drafts: $error',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget to display individual draft information
class _DraftInfo extends StatelessWidget {
  final int draftNumber;
  final Map<String, dynamic> draft;

  const _DraftInfo({
    required this.draftNumber,
    required this.draft,
  });

  @override
  Widget build(BuildContext context) {
    final draftType = draft['draft_type'] as String? ?? 'snake';
    final thirdRoundReversal = draft['third_round_reversal'] as bool? ?? false;
    final rounds = draft['rounds'] as int? ?? 15;
    final pickTimeSeconds = draft['pick_time_seconds'] as int? ?? 90;
    final settings = draft['settings'] as Map<String, dynamic>? ?? {};
    final playerPool = settings['player_pool'] as String? ?? 'all';
    final draftOrder = settings['draft_order'] as String? ?? 'randomize';
    final timerMode = settings['timer_mode'] as String? ?? 'per_pick';
    final derbyStartTimeStr = settings['derby_start_time'] as String?;
    final autoStartDerby = settings['auto_start_derby'] as bool? ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (draftNumber > 1) ...[
          const Divider(),
          const SizedBox(height: 8),
        ],
        Text(
          'Draft $draftNumber',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        InfoRow(
          label: 'Draft Type',
          value: _formatDraftType(draftType),
        ),
        if (thirdRoundReversal)
          const InfoRow(
            label: '3rd Round Reversal',
            value: 'Enabled',
          ),
        InfoRow(
          label: 'Rounds',
          value: rounds.toString(),
        ),
        InfoRow(
          label: 'Pick Time',
          value: '$pickTimeSeconds seconds',
        ),
        InfoRow(
          label: 'Player Pool',
          value: _formatPlayerPool(playerPool),
        ),
        InfoRow(
          label: 'Draft Order',
          value: _formatDraftOrder(draftOrder),
        ),
        InfoRow(
          label: 'Timer Mode',
          value: _formatTimerMode(timerMode),
        ),
        // Derby-specific fields
        if (draftOrder.toLowerCase() == 'derby') ...[
          if (derbyStartTimeStr != null) ...[
            InfoRow(
              label: 'Derby Start Time',
              value: _formatDateTime(derbyStartTimeStr),
            ),
          ] else ...[
            const InfoRow(
              label: 'Derby Start Time',
              value: 'Not set',
            ),
          ],
          InfoRow(
            label: 'Auto Start Derby',
            value: autoStartDerby ? 'Enabled' : 'Disabled',
          ),
        ],
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
        return 'All Players';
      case 'rookie':
        return 'Rookies Only';
      case 'vet':
        return 'Veterans Only';
      default:
        return pool;
    }
  }

  String _formatDraftOrder(String order) {
    switch (order.toLowerCase()) {
      case 'randomize':
        return 'Randomize';
      case 'derby':
        return 'Derby';
      default:
        return order;
    }
  }

  String _formatTimerMode(String mode) {
    switch (mode.toLowerCase()) {
      case 'per_pick':
        return 'Per Pick';
      case 'per_manager':
        return 'Per Manager';
      default:
        return mode;
    }
  }

  String _formatDateTime(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString);
      return '${dateTime.month}/${dateTime.day}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return isoString;
    }
  }
}
