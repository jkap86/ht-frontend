import 'package:flutter/material.dart';
import '../../../domain/league.dart';

/// Settings footer with cancel and save buttons
class SettingsFooter extends StatelessWidget {
  final League league;
  final Map<String, bool> expansionStates;
  final bool hasChanges;
  final bool isSubmitting;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const SettingsFooter({
    super.key,
    required this.league,
    required this.expansionStates,
    required this.hasChanges,
    required this.isSubmitting,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: isSubmitting ? null : onCancel,
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: (hasChanges && !isSubmitting) ? onSave : null,
            icon: isSubmitting
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  )
                : const Icon(Icons.save),
            label: Text(isSubmitting ? 'Saving...' : 'Save Changes'),
          ),
        ],
      ),
    );
  }
}
