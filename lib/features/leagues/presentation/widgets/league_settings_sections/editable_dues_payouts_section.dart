import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Editable dues and payouts section
class EditableDuesPayoutsSection extends StatelessWidget {
  final Map<String, dynamic> settings;
  final Function(String, dynamic) onChanged;

  const EditableDuesPayoutsSection({
    super.key,
    required this.settings,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final dues = (settings['dues'] as num?)?.toDouble() ?? 0.0;

    return Card(
      child: ExpansionTile(
        initiallyExpanded: false,
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
                // Entry Fee
                TextFormField(
                  initialValue: dues > 0 ? dues.toStringAsFixed(2) : '0',
                  decoration: const InputDecoration(
                    labelText: 'Entry Fee',
                    border: OutlineInputBorder(),
                    prefixText: '\$ ',
                    helperText: 'Amount each member pays to join (0 for free)',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  onChanged: (value) {
                    onChanged('dues', double.tryParse(value) ?? 0.0);
                  },
                ),
                const SizedBox(height: 16),

                // Note about payout structure
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onSecondaryContainer.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Payout structure configuration coming soon. For now, you can manually track payouts based on your entry fee.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Quick calculator
                if (dues > 0) ...[
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    'Quick Calculator',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildPayoutCalculator(dues),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayoutCalculator(double dues) {
    // Assuming 12 teams by default - could be dynamic
    const teams = 12;
    final totalPot = dues * teams;

    return Builder(
      builder: (context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Pot: \$${totalPot.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Common splits:',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 4),
            _buildPayoutExample('1st: 60%, 2nd: 30%, 3rd: 10%', totalPot, [0.6, 0.3, 0.1]),
            _buildPayoutExample('1st: 70%, 2nd: 30%', totalPot, [0.7, 0.3]),
            _buildPayoutExample('1st: 50%, 2nd: 30%, 3rd: 20%', totalPot, [0.5, 0.3, 0.2]),
          ],
        ),
      ),
    );
  }

  Widget _buildPayoutExample(String label, double totalPot, List<double> percentages) {
    final payouts = percentages.map((p) => totalPot * p).toList();
    final payoutText = payouts.map((p) => '\$${p.toStringAsFixed(2)}').join(', ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        '$label = $payoutText',
        style: const TextStyle(fontSize: 11),
      ),
    );
  }
}
