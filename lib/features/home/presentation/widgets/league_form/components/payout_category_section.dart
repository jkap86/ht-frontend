import 'package:flutter/material.dart';
import 'payout_row.dart';
import '../utils/payout_helpers.dart';

/// A single payout category section with expandable places
class PayoutCategorySection extends StatelessWidget {
  final String type;
  final bool enabled;
  final List<int> visiblePlaces;
  final Map<int, Map<String, dynamic>> categoryPayouts;
  final int totalRosters;
  final double totalPot;
  final VoidCallback onToggleEnabled;
  final VoidCallback onRemoveCategory;
  final Function(int place) onAddPlace;
  final Function(int place) onRemovePlace;
  final VoidCallback onPayoutChanged;

  const PayoutCategorySection({
    super.key,
    required this.type,
    required this.enabled,
    required this.visiblePlaces,
    required this.categoryPayouts,
    required this.totalRosters,
    required this.totalPot,
    required this.onToggleEnabled,
    required this.onRemoveCategory,
    required this.onAddPlace,
    required this.onRemovePlace,
    required this.onPayoutChanged,
  });

  @override
  Widget build(BuildContext context) {
    final title = PayoutHelpers.getCategoryTitle(type);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: onToggleEnabled,
                    child: Row(
                      children: [
                        Icon(
                          enabled ? Icons.expand_more : Icons.chevron_right,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  color: Colors.red,
                  onPressed: onRemoveCategory,
                  tooltip: 'Remove Category',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            if (enabled) ...[
              const SizedBox(height: 8),
              ...visiblePlaces.map((place) {
                if (!categoryPayouts.containsKey(place)) {
                  categoryPayouts[place] = {'percentage': 0.0, 'amount': 0.0};
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: PayoutRow(
                    label: PayoutHelpers.getOrdinal(place),
                    payout: categoryPayouts[place]!,
                    totalPot: totalPot,
                    onRemove: () => onRemovePlace(place),
                    onChanged: onPayoutChanged,
                  ),
                );
              }),
              if (visiblePlaces.length < totalRosters)
                Center(
                  child: IconButton(
                    icon: const Icon(Icons.add_circle_outline, size: 24),
                    color: Theme.of(context).primaryColor,
                    onPressed: () => onAddPlace(visiblePlaces.length + 1),
                    tooltip: 'Add ${PayoutHelpers.getOrdinal(visiblePlaces.length + 1)} Place',
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
