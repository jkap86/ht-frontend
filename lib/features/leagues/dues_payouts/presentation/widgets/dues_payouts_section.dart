import 'package:flutter/material.dart';
import '../../../presentation/widgets/league_settings_sections/info_row.dart';

/// Dumb widget displaying dues and payouts
class DuesPayoutsSection extends StatelessWidget {
  final Map<String, dynamic> settings;
  final bool? initiallyExpanded;
  final Function(bool)? onExpansionChanged;

  const DuesPayoutsSection({
    super.key,
    required this.settings,
    this.initiallyExpanded,
    this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final dues = (settings['dues'] as num?)?.toDouble() ?? 0.0;
    final payoutStructure = settings['payout_structure'] as List<dynamic>?;

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
                if (payoutStructure != null && payoutStructure.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Payout Structure',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...payoutStructure.map((payout) {
                    final payoutMap = payout as Map<String, dynamic>;
                    final type = payoutMap['type'] as String?;
                    final place = payoutMap['place'] as int?;
                    final percentage =
                        (payoutMap['percentage'] as num?)?.toDouble();
                    final amount = (payoutMap['amount'] as num?)?.toDouble();

                    String label = _getPayoutLabel(type, place);
                    String value = '';

                    if (percentage != null) {
                      value = '${percentage.toStringAsFixed(0)}%';
                      if (amount != null) {
                        value += ' (\$${amount.toStringAsFixed(2)})';
                      }
                    } else if (amount != null) {
                      value = '\$${amount.toStringAsFixed(2)}';
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: InfoRow(label: label, value: value),
                    );
                  }),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPayoutLabel(String? type, int? place) {
    if (type == 'placement') {
      return '${_getOrdinal(place ?? 1)} Place';
    } else if (type == 'placement_points') {
      return '${_getOrdinal(place ?? 1)} Most Points';
    } else if (type == 'highest_weekly_score') {
      return 'Highest Week Score';
    } else if (type == 'regular_season_winner') {
      return 'Regular Season Winner';
    } else if (type == 'highest_points_non_playoff') {
      return 'Highest Points (Non-Playoff)';
    }
    return 'Payout';
  }

  String _getOrdinal(int place) {
    if (place == 1) return '1st';
    if (place == 2) return '2nd';
    if (place == 3) return '3rd';
    return '${place}th';
  }
}
