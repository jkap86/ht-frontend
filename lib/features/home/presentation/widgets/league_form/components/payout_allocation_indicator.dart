import 'package:flutter/material.dart';

/// Displays the allocation status of payouts (remaining, over-allocated, or fully allocated)
class PayoutAllocationIndicator extends StatelessWidget {
  final double entryFee;
  final int totalRosters;
  final double totalAllocatedPercentage;

  const PayoutAllocationIndicator({
    super.key,
    required this.entryFee,
    required this.totalRosters,
    required this.totalAllocatedPercentage,
  });

  @override
  Widget build(BuildContext context) {
    if (entryFee <= 0) return const SizedBox.shrink();

    final totalPot = entryFee * totalRosters;
    final remainingPct = 100.0 - totalAllocatedPercentage;
    final remainingAmount = totalPot * remainingPct / 100;

    Color color;
    String message;
    IconData icon;

    if (remainingPct > 0.01) {
      color = Colors.orange;
      message = 'Remaining: ${remainingPct.toStringAsFixed(1)}% (\$${remainingAmount.toStringAsFixed(2)})';
      icon = Icons.warning_amber;
    } else if (remainingPct < -0.01) {
      color = Colors.red;
      message = 'Over-allocated: ${remainingPct.abs().toStringAsFixed(1)}% (\$${remainingAmount.abs().toStringAsFixed(2)})';
      icon = Icons.error;
    } else {
      color = Colors.green;
      message = 'Fully Allocated ✓';
      icon = Icons.check_circle;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
