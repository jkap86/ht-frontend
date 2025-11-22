import 'package:flutter/material.dart';

/// Header bar for draft cards showing summary information
class DraftHeaderBar extends StatelessWidget {
  final String draftName;
  final String draftTypeLabel;
  final int rounds;
  final String playerPoolLabel;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;

  const DraftHeaderBar({
    super.key,
    required this.draftName,
    required this.draftTypeLabel,
    required this.rounds,
    required this.playerPoolLabel,
    required this.isExpanded,
    required this.onToggleExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggleExpanded,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    draftName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Summary info
                  Row(
                    children: [
                      SummaryChip(
                        label: draftTypeLabel,
                        icon: Icons.swap_vert,
                      ),
                      const SizedBox(width: 8),
                      SummaryChip(
                        label: '$rounds rounds',
                        icon: Icons.repeat,
                      ),
                      const SizedBox(width: 8),
                      SummaryChip(
                        label: playerPoolLabel,
                        icon: Icons.people,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
          ],
        ),
      ),
    );
  }
}

/// Small chip for summary information
class SummaryChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const SummaryChip({
    super.key,
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
