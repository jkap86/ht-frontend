import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/league.dart';
import '../../application/edit_league_controller.dart';
import 'league_settings_sections/editable_scoring_settings_section.dart';
import 'league_settings_sections/editable_roster_positions_section.dart';
import 'league_settings_sections/editable_waiver_settings_section.dart';
import 'league_settings_sections/editable_dues_payouts_section.dart';
import 'league_settings_sections/editable_draft_settings_section.dart';
import 'league_settings_sections/danger_zone_section.dart';

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
          SnackBar(
            content: const Text('League settings updated successfully'),
            backgroundColor: Theme.of(context).colorScheme.tertiary,
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
                          color: Theme.of(context).colorScheme.errorContainer,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Theme.of(context).colorScheme.onErrorContainer,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    state.error!,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onErrorContainer,
                                    ),
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
                      onNameChanged: controller.updateName,
                    ),
                    const SizedBox(height: 16),

                    // Schedule Settings (editable)
                    if (state.editedLeague.settings != null) ...[
                      _EditableScheduleSection(
                        settings: state.editedLeague.settings!,
                        onChanged: controller.updateSetting,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Draft Settings (editable)
                    EditableDraftSettingsSection(
                      leagueId: league.id,
                      rosterPositions: state.editedLeague.rosterPositions,
                      isCommissioner: league.isCommissioner,
                    ),
                    const SizedBox(height: 16),

                    // Scoring Settings (editable)
                    if (state.editedLeague.scoringSettings != null) ...[
                      EditableScoringSettingsSection(
                        scoringSettings: state.editedLeague.scoringSettings!,
                        onChanged: controller.updateScoringSetting,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Roster Positions (editable)
                    if (state.editedLeague.rosterPositions != null) ...[
                      EditableRosterPositionsSection(
                        rosterPositions: state.editedLeague.rosterPositions!,
                        onChanged: controller.updateRosterPosition,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Waiver Settings (editable)
                    if (state.editedLeague.settings != null) ...[
                      EditableWaiverSettingsSection(
                        settings: state.editedLeague.settings!,
                        onChanged: controller.updateSetting,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Dues & Payouts (editable)
                    if (state.editedLeague.settings != null) ...[
                      EditableDuesPayoutsSection(
                        settings: state.editedLeague.settings!,
                        onChanged: controller.updateSetting,
                        league: league,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Danger Zone (always visible for commissioners)
                    DangerZoneSection(league: league),
                    const SizedBox(height: 16),
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

/// Editable basic info section
class _EditableBasicInfoSection extends StatelessWidget {
  final String name;
  final Function(String) onNameChanged;

  const _EditableBasicInfoSection({
    required this.name,
    required this.onNameChanged,
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
            child: TextFormField(
              initialValue: name,
              decoration: const InputDecoration(
                labelText: 'League Name *',
                border: OutlineInputBorder(),
                helperText: 'Must be at least 3 characters',
              ),
              onChanged: onNameChanged,
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
