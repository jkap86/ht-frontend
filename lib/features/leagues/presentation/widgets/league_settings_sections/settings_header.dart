import 'package:flutter/material.dart';
import '../../../domain/league.dart';

/// Settings modal header with close and reset buttons
class SettingsHeader extends StatelessWidget {
  final League league;
  final Map<String, bool> expansionStates;
  final VoidCallback onClose;
  final bool hasChanges;
  final VoidCallback onReset;

  const SettingsHeader({
    super.key,
    required this.league,
    required this.expansionStates,
    required this.onClose,
    required this.hasChanges,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.edit,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Edit League Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          if (hasChanges)
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: onReset,
              tooltip: 'Reset changes',
            ),
          IconButton(
            icon: Icon(
              Icons.close,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}
