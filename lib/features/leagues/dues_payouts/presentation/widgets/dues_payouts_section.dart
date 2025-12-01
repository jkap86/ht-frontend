import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../presentation/widgets/league_settings_sections/info_row.dart';
import '../../domain/payout.dart';
import '../../application/payouts_provider.dart';

/// Widget displaying dues and payouts (view-only)
class DuesPayoutsSection extends ConsumerWidget {
  final Map<String, dynamic> settings;
  final int leagueId;
  final bool? initiallyExpanded;
  final Function(bool)? onExpansionChanged;

  const DuesPayoutsSection({
    super.key,
    required this.settings,
    required this.leagueId,
    this.initiallyExpanded,
    this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dues = (settings['dues'] as num?)?.toDouble() ?? 0.0;
    final payoutsAsync = ref.watch(payoutsProvider(leagueId));

    return Card(
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded ?? false,
        onExpansionChanged: onExpansionChanged,
        title: const Text(
          'Dues & Payouts',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoRow(
                  label: 'Entry Fee',
                  value: dues > 0 ? '\$${dues.toStringAsFixed(2)}' : 'Free',
                ),
                const SizedBox(height: 16),
                payoutsAsync.when(
                  data: (payouts) => _buildPayoutsDisplay(context, payouts),
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (error, stack) => Text(
                    'Error loading payouts',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayoutsDisplay(BuildContext context, List<Payout> payouts) {
    if (payouts.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(Icons.info_outline, size: 18),
            SizedBox(width: 8),
            Text(
              'No payouts configured',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      );
    }

    // Group payouts by type
    final playoffPayouts = payouts.where((p) => p.type == PayoutType.playoffFinish).toList()
      ..sort((a, b) => a.place.compareTo(b.place));
    final regSeasonPayouts = payouts.where((p) => p.type == PayoutType.regSeasonPoints).toList()
      ..sort((a, b) => a.place.compareTo(b.place));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payout Structure',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (playoffPayouts.isNotEmpty) ...[
          _buildPayoutTypeGroup(context, 'Playoff Finish', playoffPayouts),
          const SizedBox(height: 8),
        ],
        if (regSeasonPayouts.isNotEmpty) ...[
          _buildPayoutTypeGroup(context, 'Reg Season Points', regSeasonPayouts),
        ],
      ],
    );
  }

  Widget _buildPayoutTypeGroup(BuildContext context, String title, List<Payout> payouts) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(7),
                topRight: Radius.circular(7),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  title.contains('Playoff') ? Icons.emoji_events : Icons.trending_up,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          ...payouts.map((payout) => _buildPayoutRow(context, payout)),
        ],
      ),
    );
  }

  Widget _buildPayoutRow(BuildContext context, Payout payout) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              '${payout.place}',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${payout.displayPlace} Place',
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Text(
            payout.displayAmount,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
