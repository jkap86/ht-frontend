import 'package:flutter/material.dart';

/// Widget that displays the normal draft order (non-derby) as a sorted list
class NormalDraftOrderList extends StatelessWidget {
  final List<Map<String, dynamic>> order;

  const NormalDraftOrderList({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    // Sort by draft position
    final sortedOrder = order
        .where((item) => item['draftPosition'] != null)
        .toList()
      ..sort((a, b) {
        final posA = (a['draftPosition'] as int?) ?? 999;
        final posB = (b['draftPosition'] as int?) ?? 999;
        return posA.compareTo(posB);
      });

    return Column(
      children: sortedOrder
          .map((item) {
        final position = (item['draftPosition'] as num?)?.toInt() ?? 0;
        final username = item['username'] as String? ??
            'Team ${item['rosterId']}';

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
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer,
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
  }
}
