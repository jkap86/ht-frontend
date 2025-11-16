import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/league.dart';
import '../../application/edit_league_controller.dart';

/// Editable league settings modal for commissioners
class EditLeagueSettingsModal extends ConsumerWidget {
  final League league;

  const EditLeagueSettingsModal({
    super.key,
    required this.league,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(editLeagueControllerProvider(league));
    final controller = ref.read(editLeagueControllerProvider(league).notifier);

    // Show success and close modal
    ref.listen(editLeagueControllerProvider(league), (previous, next) {
      if (next.isSuccess) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('League settings updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
        child: Column(
          children: [
            // Header
            _SettingsHeader(
              onClose: () => Navigator.of(context).pop(),
              hasChanges: state.hasChanges,
              onReset: controller.resetChanges,
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Show error if any
                    if (state.error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Card(
                          color: Colors.red.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline,
                                    color: Colors.red.shade700),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    state.error!,
                                    style: TextStyle(color: Colors.red.shade700),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    // Basic Info (editable)
                    _EditableBasicInfoSection(
                      name: state.editedLeague.name,
                      description: state.editedLeague.description,
                      onNameChanged: controller.updateName,
                      onDescriptionChanged: controller.updateDescription,
                    ),
                    const SizedBox(height: 16),

                    // Schedule Settings (editable)
                    if (state.editedLeague.settings != null)
                      _EditableScheduleSection(
                        settings: state.editedLeague.settings!,
                        onChanged: controller.updateSetting,
                      ),
                    const SizedBox(height: 16),

                    // Note: Can add more editable sections here
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Note: Additional settings (Scoring, Roster Positions, Waivers, Dues) can be edited in future updates.',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Footer with actions
            _SettingsFooter(
              hasChanges: state.hasChanges,
              isSubmitting: state.isSubmitting,
              onCancel: () => Navigator.of(context).pop(),
              onSave: controller.submitChanges,
            ),
          ],
        ),
      ),
    );
  }
}

/// Settings modal header with close and reset buttons
class _SettingsHeader extends StatelessWidget {
  final VoidCallback onClose;
  final bool hasChanges;
  final VoidCallback onReset;

  const _SettingsHeader({
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
          const Icon(Icons.edit, color: Colors.white),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Edit League Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          if (hasChanges)
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: onReset,
              tooltip: 'Reset changes',
            ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

/// Editable basic info section
class _EditableBasicInfoSection extends StatelessWidget {
  final String name;
  final String? description;
  final Function(String) onNameChanged;
  final Function(String?) onDescriptionChanged;

  const _EditableBasicInfoSection({
    required this.name,
    required this.description,
    required this.onNameChanged,
    required this.onDescriptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        title: const Text(
          'Basic Information',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: name,
                  decoration: const InputDecoration(
                    labelText: 'League Name *',
                    border: OutlineInputBorder(),
                    helperText: 'Must be at least 3 characters',
                  ),
                  onChanged: onNameChanged,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: description ?? '',
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    helperText: 'Optional league description',
                  ),
                  maxLines: 3,
                  onChanged: onDescriptionChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Editable schedule section
class _EditableScheduleSection extends StatelessWidget {
  final Map<String, dynamic> settings;
  final Function(String, dynamic) onChanged;

  const _EditableScheduleSection({
    required this.settings,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final playoffsEnabled = settings['playoffs_enabled'] == true;

    return Card(
      child: ExpansionTile(
        initiallyExpanded: false,
        title: const Text(
          'Schedule',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: settings['start_week']?.toString() ?? '1',
                        decoration: const InputDecoration(
                          labelText: 'Start Week',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) =>
                            onChanged('start_week', int.tryParse(value) ?? 1),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        initialValue:
                            settings['end_week']?.toString() ?? '14',
                        decoration: const InputDecoration(
                          labelText: 'End Week',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) =>
                            onChanged('end_week', int.tryParse(value) ?? 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Enable Playoffs'),
                  value: playoffsEnabled,
                  onChanged: (value) => onChanged('playoffs_enabled', value),
                ),
                if (playoffsEnabled) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: settings['playoff_week_start']
                                  ?.toString() ??
                              '15',
                          decoration: const InputDecoration(
                            labelText: 'Playoff Start Week',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => onChanged(
                              'playoff_week_start', int.tryParse(value) ?? 15),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          initialValue:
                              settings['playoff_teams']?.toString() ?? '4',
                          decoration: const InputDecoration(
                            labelText: 'Playoff Teams',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => onChanged(
                              'playoff_teams', int.tryParse(value) ?? 4),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Settings footer with cancel and save buttons
class _SettingsFooter extends StatelessWidget {
  final bool hasChanges;
  final bool isSubmitting;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const _SettingsFooter({
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
        color: Colors.grey.shade100,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
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
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
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
