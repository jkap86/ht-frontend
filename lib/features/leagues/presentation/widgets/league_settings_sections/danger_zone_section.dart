import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/leagues_provider.dart';
import '../../../domain/league.dart';

/// Danger Zone section - only visible to commissioners
/// Contains destructive actions like reset and delete league
class DangerZoneSection extends ConsumerWidget {
  final League league;
  final bool? initiallyExpanded;
  final Function(bool)? onExpansionChanged;

  const DangerZoneSection({
    super.key,
    required this.league,
    this.initiallyExpanded,
    this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only show for commissioners
    if (!league.isCommissioner) {
      return const SizedBox.shrink();
    }

    return Card(
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded ?? false,
        onExpansionChanged: onExpansionChanged,
        title: const Text(
          'Danger Zone',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Warning banner
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red.shade700, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Destructive actions that cannot be undone',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Reset League
                _DangerAction(
                  icon: Icons.refresh,
                  title: 'Reset League',
                  description: 'Clear all rosters, drafts, and matchups. League settings will be preserved.',
                  buttonLabel: 'Reset League',
                  onPressed: () => _showResetConfirmation(context, ref),
                ),

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),

                // Delete League
                _DangerAction(
                  icon: Icons.delete_forever,
                  title: 'Delete League',
                  description: 'Permanently delete this league and all associated data. This action cannot be undone.',
                  buttonLabel: 'Delete League',
                  isPrimaryDanger: true,
                  onPressed: () => _showDeleteConfirmation(context, ref),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showResetConfirmation(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => _ConfirmationDialog(
        title: 'Reset League?',
        content: 'This will clear all rosters, draft picks, and matchups. '
            'League settings and members will be preserved.\n\n'
            'This action cannot be undone.',
        confirmLabel: 'Reset League',
        isDanger: true,
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(leaguesRepositoryProvider).resetLeague(league.id);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('League has been reset successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(); // Close settings modal
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to reset league: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _showDeleteConfirmation(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => _ConfirmationDialog(
        title: 'Delete League?',
        content: 'This will permanently delete "${league.name}" and all associated data including:\n\n'
            '• All rosters and teams\n'
            '• Draft history\n'
            '• Matchups and results\n'
            '• League chat messages\n'
            '• All league settings\n\n'
            'This action cannot be undone.',
        confirmLabel: 'Delete League',
        isDanger: true,
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(leaguesRepositoryProvider).deleteLeague(league.id);

        if (context.mounted) {
          // Refresh leagues list
          ref.invalidate(myLeaguesProvider);

          // Close all dialogs and navigate to home
          Navigator.of(context).popUntil((route) => route.isFirst);
          context.go('/home');

          // Show success message after navigation
          Future.delayed(const Duration(milliseconds: 300), () {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('League has been deleted'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          });
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete league: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}

/// Individual danger action widget
class _DangerAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String buttonLabel;
  final bool isPrimaryDanger;
  final VoidCallback onPressed;

  const _DangerAction({
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonLabel,
    this.isPrimaryDanger = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dangerColor = isPrimaryDanger ? Colors.red.shade900 : Colors.orange.shade700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: dangerColor, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: dangerColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 18),
          label: Text(buttonLabel),
          style: OutlinedButton.styleFrom(
            foregroundColor: dangerColor,
            side: BorderSide(color: dangerColor, width: 1.5),
          ),
        ),
      ],
    );
  }
}

/// Confirmation dialog for destructive actions
class _ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmLabel;
  final bool isDanger;

  const _ConfirmationDialog({
    required this.title,
    required this.content,
    required this.confirmLabel,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.warning,
            color: isDanger ? Colors.red.shade700 : Colors.orange.shade700,
          ),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: isDanger ? Colors.red.shade700 : Colors.orange.shade700,
          ),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
