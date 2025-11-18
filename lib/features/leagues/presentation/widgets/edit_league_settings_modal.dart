import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/league.dart';
import '../../application/edit_league_controller.dart';
import 'league_settings_sections/editable_dues_payouts_section.dart';
import 'league_settings_sections/editable_draft_settings_section.dart';
import 'league_settings_sections/danger_zone_section.dart';
import 'league_settings_sections/info_row.dart';
import '../../../../shared/models/settings_mode.dart';
import '../../../../shared/widgets/settings/shared_schedule_section.dart';
import '../../../../shared/widgets/settings/shared_scoring_settings_section.dart';
import '../../../../shared/widgets/settings/shared_roster_positions_section.dart';
import '../../../../shared/widgets/settings/shared_waiver_settings_section.dart';
import 'league_settings_modal.dart';

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

    // Show success and reopen view modal
    ref.listen(editLeagueControllerProvider(league), (previous, next) {
      if (next.isSuccess) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('League settings updated successfully'),
            backgroundColor: Theme.of(context).colorScheme.tertiary,
          ),
        );
        // Reopen the read-only modal after save
        showDialog(
          context: context,
          builder: (context) => LeagueSettingsModal(league: league),
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
              league: league,
              onClose: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (context) => LeagueSettingsModal(league: league),
                );
              },
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
                      league: state.editedLeague,
                      onNameChanged: controller.updateName,
                    ),
                    const SizedBox(height: 16),

                    // Schedule Settings (editable)
                    if (state.editedLeague.settings != null) ...[
                      SharedScheduleSection(
                        mode: SettingsMode.edit,
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
                      SharedScoringSettingsSection(
                        mode: SettingsMode.edit,
                        scoringSettings: state.editedLeague.scoringSettings!,
                        onChanged: controller.updateScoringSetting,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Roster Positions (editable)
                    if (state.editedLeague.rosterPositions != null) ...[
                      SharedRosterPositionsSection(
                        mode: SettingsMode.edit,
                        rosterPositions: state.editedLeague.rosterPositions!,
                        onChanged: controller.updateRosterPosition,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Waiver Settings (editable)
                    if (state.editedLeague.settings != null) ...[
                      SharedWaiverSettingsSection(
                        mode: SettingsMode.edit,
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
              league: league,
              hasChanges: state.hasChanges,
              isSubmitting: state.isSubmitting,
              onCancel: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (context) => LeagueSettingsModal(league: league),
                );
              },
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
  final League league;
  final VoidCallback onClose;
  final bool hasChanges;
  final VoidCallback onReset;

  const _SettingsHeader({
    required this.league,
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
  final League league;
  final Function(String) onNameChanged;

  const _EditableBasicInfoSection({
    required this.league,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Editable League Name
                TextFormField(
                  initialValue: league.name,
                  decoration: const InputDecoration(
                    labelText: 'League Name *',
                    border: OutlineInputBorder(),
                    helperText: 'Must be at least 3 characters',
                  ),
                  onChanged: onNameChanged,
                ),
                const SizedBox(height: 16),

                // Read-only fields (matching view mode)
                InfoRow(
                  label: 'Season',
                  value: league.season,
                ),
                InfoRow(
                  label: 'Season Type',
                  value: _formatSeasonType(league.seasonType),
                ),
                InfoRow(
                  label: 'Status',
                  value: _formatStatus(league.status),
                ),
                InfoRow(
                  label: 'Total Teams',
                  value: '${league.totalRosters}',
                ),
                InfoRow(
                  label: 'League Type',
                  value: league.settings?['is_public'] == true ? 'Public' : 'Private',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatSeasonType(String seasonType) {
    switch (seasonType.toLowerCase()) {
      case 'regular':
        return 'Regular Season';
      case 'playoff':
        return 'Playoff';
      case 'dynasty':
        return 'Dynasty';
      default:
        return seasonType;
    }
  }

  String _formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pre_draft':
        return 'Pre-Draft';
      case 'drafting':
        return 'Drafting';
      case 'in_season':
        return 'In Season';
      case 'complete':
        return 'Complete';
      default:
        return status;
    }
  }
}


/// Settings footer with cancel and save buttons
class _SettingsFooter extends StatelessWidget {
  final League league;
  final bool hasChanges;
  final bool isSubmitting;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const _SettingsFooter({
    required this.league,
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
