import 'package:flutter/material.dart';
import '../../domain/league.dart';

/// Displays league buy-in and payout structure
/// Extracted component for better composition
class LeagueBuyInCard extends StatelessWidget {
  final League league;
  final double dues;

  const LeagueBuyInCard({
    super.key,
    required this.league,
    required this.dues,
  });

  @override
  Widget build(BuildContext context) {
    final totalPot = dues * league.totalRosters;
    final payoutStructure = league.settings?['payout_structure'] as List<dynamic>?;

    return Card(
      child: ExpansionTile(
        initiallyExpanded: false,
        leading: const Icon(Icons.attach_money),
        title: Text(
          'Buy-In: \$${dues.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text('Total Pot: \$${totalPot.toStringAsFixed(2)}'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildPayoutStructure(payoutStructure),
          ),
        ],
      ),
    );
  }

  Widget _buildPayoutStructure(List<dynamic>? payoutStructure) {
    if (payoutStructure == null || payoutStructure.isEmpty) {
      return const Text(
        'No payout structure configured',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payout Structure',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...payoutStructure.map((payout) {
          final payoutMap = payout as Map<String, dynamic>;
          return _PayoutRow(payoutMap: payoutMap);
        }),
      ],
    );
  }
}

/// Row displaying a single payout entry
class _PayoutRow extends StatelessWidget {
  final Map<String, dynamic> payoutMap;

  const _PayoutRow({required this.payoutMap});

  @override
  Widget build(BuildContext context) {
    final type = payoutMap['type'] as String?;
    final place = payoutMap['place'] as int?;
    final percentage = (payoutMap['percentage'] as num?)?.toDouble();
    final amount = (payoutMap['amount'] as num?)?.toDouble();

    final label = _getPayoutLabel(type, place);
    final value = _formatPayoutValue(percentage, amount);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
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

  String _formatPayoutValue(double? percentage, double? amount) {
    if (percentage != null) {
      String value = '${percentage.toStringAsFixed(0)}%';
      if (amount != null) {
        value += ' (\$${amount.toStringAsFixed(2)})';
      }
      return value;
    } else if (amount != null) {
      return '\$${amount.toStringAsFixed(2)}';
    }
    return '-';
  }

  String _getOrdinal(int place) {
    if (place == 1) return '1st';
    if (place == 2) return '2nd';
    if (place == 3) return '3rd';
    return '${place}th';
  }
}
