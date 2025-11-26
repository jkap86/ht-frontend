import 'package:flutter/material.dart';
import '../utils/payout_helpers.dart';

/// Popup menu button for adding new payout categories
class PayoutCategorySelector extends StatelessWidget {
  final List<String> addedCategories;
  final Function(String type) onCategorySelected;

  const PayoutCategorySelector({
    super.key,
    required this.addedCategories,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PopupMenuButton<String>(
        onSelected: onCategorySelected,
        itemBuilder: (context) {
          final availableCategories = PayoutHelpers.availableCategories;
          final available = availableCategories.entries
              .where((e) => !addedCategories.contains(e.key))
              .toList();

          if (available.isEmpty) {
            return [
              const PopupMenuItem<String>(
                enabled: false,
                child: Text('All categories added'),
              ),
            ];
          }

          return available
              .map((e) => PopupMenuItem<String>(
                    value: e.key,
                    child: Text(e.value),
                  ))
              .toList();
        },
        child: TextButton.icon(
          onPressed: null,
          icon: const Icon(Icons.add_circle_outline, size: 20),
          label: const Text('Add Payout Category'),
        ),
      ),
    );
  }
}
