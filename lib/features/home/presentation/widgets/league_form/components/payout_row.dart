import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Individual payout row with percentage and dollar amount inputs
class PayoutRow extends StatelessWidget {
  final String label;
  final Map<String, dynamic> payout;
  final double totalPot;
  final VoidCallback? onRemove;
  final VoidCallback onChanged;

  const PayoutRow({
    super.key,
    required this.label,
    required this.payout,
    required this.totalPot,
    this.onRemove,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Create controllers if they don't exist
    if (!payout.containsKey('_pctController')) {
      final percentage = (payout['percentage'] as num?)?.toDouble() ?? 0.0;
      payout['_pctController'] = TextEditingController(
        text: percentage > 0 ? percentage.toStringAsFixed(1) : '',
      );
    }
    if (!payout.containsKey('_amtController')) {
      final amount = (payout['amount'] as num?)?.toDouble() ?? 0.0;
      payout['_amtController'] = TextEditingController(
        text: amount > 0 ? amount.toStringAsFixed(2) : '',
      );
    }

    final pctController = payout['_pctController'] as TextEditingController;
    final amtController = payout['_amtController'] as TextEditingController;

    return Row(
      children: [
        if (label.isNotEmpty) ...[
          SizedBox(
            width: 40,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: TextField(
            controller: pctController,
            decoration: const InputDecoration(
              labelText: 'Percentage',
              border: OutlineInputBorder(),
              suffixText: '%',
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            ),
            style: const TextStyle(fontSize: 12),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
            ],
            onChanged: (value) {
              final newPercentage = double.tryParse(value) ?? 0.0;
              payout['percentage'] = newPercentage;
              final newAmount = totalPot * newPercentage / 100;
              payout['amount'] = newAmount;
              amtController.text = newAmount > 0 ? newAmount.toStringAsFixed(2) : '';
              onChanged();
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: amtController,
            decoration: const InputDecoration(
              labelText: 'Dollar Amount',
              border: OutlineInputBorder(),
              prefixText: '\$',
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            ),
            style: const TextStyle(fontSize: 12),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            onChanged: (value) {
              final newAmount = double.tryParse(value) ?? 0.0;
              payout['amount'] = newAmount;
              final newPercentage = totalPot > 0 ? (newAmount / totalPot * 100) : 0.0;
              payout['percentage'] = newPercentage;
              pctController.text = newPercentage > 0 ? newPercentage.toStringAsFixed(1) : '';
              onChanged();
            },
          ),
        ),
        if (onRemove != null) ...[
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, size: 18),
            color: Colors.red,
            onPressed: onRemove,
            tooltip: 'Remove',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ],
    );
  }
}
