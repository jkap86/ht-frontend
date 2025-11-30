import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/league.dart';
import '../../domain/draft.dart';
import '../../application/drafts_provider.dart';
import '../../../presentation/widgets/league_settings_sections/info_row.dart';

/// Read-only widget displaying draft settings
class DraftSettingsSection extends ConsumerWidget {
  final League league;
  final bool? initiallyExpanded;
  final Function(bool)? onExpansionChanged;

  const DraftSettingsSection({
    super.key,
    required this.league,
    this.initiallyExpanded,
    this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftsAsync = ref.watch(leagueDraftsProvider(league.id));

    return Card(
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded ?? false,
        onExpansionChanged: onExpansionChanged,
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
  final Draft draft;

  const _DraftInfo({
    required this.draftNumber,
    required this.draft,
  });

  @override
  Widget build(BuildContext context) {
    final draftType = draft.draftType;
    final thirdRoundReversal = draft.thirdRoundReversal;
    final rounds = draft.rounds;
    final pickTimeSeconds = draft.pickTimeSeconds ?? 90;
    final settings = draft.settings;
    final playerPool = settings?.playerPool ?? 'all';
    final draftOrder = settings?.draftOrder ?? 'random';
    // Note: timerMode and autoStartDerby are not in the DraftSettings model yet
    // These will need to be added to the model or handled differently
    final derbyStartTime = settings?.derbyStartTime;

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
        // Derby-specific fields
        if (draftOrder.toLowerCase() == 'derby') ...[
          if (derbyStartTime != null) ...[
            InfoRow(
              label: 'Derby Start Time',
              value: _formatDateTime(derbyStartTime.toIso8601String()),
            ),
          ] else ...[
            const InfoRow(
              label: 'Derby Start Time',
              value: 'Not set',
            ),
          ],
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
      case 'random':
        return 'Randomize';
      case 'derby':
        return 'Derby';
      default:
        return order;
    }
  }

  String _formatDateTime(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString).toLocal();
      return '${dateTime.month}/${dateTime.day}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return isoString;
    }
  }
}
