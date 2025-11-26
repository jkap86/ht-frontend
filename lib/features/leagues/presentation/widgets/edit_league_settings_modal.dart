import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/league.dart';
import '../../application/edit_league_controller.dart';
import '../../dues_payouts/presentation/widgets/editable_dues_payouts_section.dart';
import '../../drafts/presentation/widgets/editable_draft_settings_section.dart';
import 'league_settings_sections/danger_zone_section.dart';
import 'league_settings_sections/error_card.dart';
import 'league_settings_sections/league_name_input.dart';
import 'league_settings_sections/settings_header.dart';
import 'league_settings_sections/settings_footer.dart';
import 'league_settings_sections/editable_basic_info_section.dart';
import '../../../../shared/models/settings_mode.dart';
import '../../../../shared/widgets/settings/shared_schedule_section.dart';
import '../../../../shared/widgets/settings/shared_scoring_settings_section.dart';
import '../../../../shared/widgets/settings/shared_roster_positions_section.dart';
import '../../../../shared/widgets/settings/shared_waiver_settings_section.dart';
import 'league_settings_modal.dart';

/// Editable league settings modal for commissioners
class EditLeagueSettingsModal extends ConsumerStatefulWidget {
  final League league;
  final Map<String, bool>? initialExpansionStates;

  const EditLeagueSettingsModal({
    super.key,
    required this.league,
    this.initialExpansionStates,
  });

  @override
  ConsumerState<EditLeagueSettingsModal> createState() => _EditLeagueSettingsModalState();
}

class _EditLeagueSettingsModalState extends ConsumerState<EditLeagueSettingsModal> {
  late Map<String, bool> _expansionStates;

  @override
  void initState() {
    super.initState();
    // Initialize expansion states with provided values or defaults
    // For edit mode, default to expanded for most sections
    _expansionStates = {
      'basic_info': widget.initialExpansionStates?['basic_info'] ?? true,
      'schedule': widget.initialExpansionStates?['schedule'] ?? true,
      'scoring': widget.initialExpansionStates?['scoring'] ?? true,
      'roster_positions': widget.initialExpansionStates?['roster_positions'] ?? true,
      'waiver_settings': widget.initialExpansionStates?['waiver_settings'] ?? true,
      'draft_settings': widget.initialExpansionStates?['draft_settings'] ?? false,
      'dues_payouts': widget.initialExpansionStates?['dues_payouts'] ?? false,
      'danger_zone': widget.initialExpansionStates?['danger_zone'] ?? false,
    };
  }

  void _updateExpansionState(String key, bool isExpanded) {
    setState(() {
      _expansionStates[key] = isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editLeagueControllerProvider(widget.league));
    final controller = ref.read(editLeagueControllerProvider(widget.league).notifier);

    // Show success and reopen view modal
    ref.listen(editLeagueControllerProvider(widget.league), (previous, next) {
      if (next.isSuccess) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('League settings updated successfully'),
            backgroundColor: Theme.of(context).colorScheme.tertiary,
          ),
        );
        // Reopen the read-only modal after save with expansion states
        showDialog(
          context: context,
          builder: (context) => LeagueSettingsModal(
            league: widget.league,
            initialExpansionStates: _expansionStates,
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
            SettingsHeader(
              league: widget.league,
              expansionStates: _expansionStates,
              onClose: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (context) => LeagueSettingsModal(
                    league: widget.league,
                    initialExpansionStates: _expansionStates,
                  ),
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
                      ErrorCard(error: state.error!),

                    // League Name Input
                    LeagueNameInput(
                      leagueName: state.editedLeague.name,
                      onNameChanged: controller.updateName,
                    ),
                    const SizedBox(height: 16),

                    // Basic Info (editable)
                    EditableBasicInfoSection(
                      league: state.editedLeague,
                      onTotalRostersChanged: controller.updateTotalRosters,
                      onIsPublicChanged: (value) => controller.updateSetting('is_public', value),
                      onSettingChanged: controller.updateSetting,
                      initiallyExpanded: _expansionStates['basic_info'],
                      onExpansionChanged: (isExpanded) => _updateExpansionState('basic_info', isExpanded),
                    ),
                    const SizedBox(height: 16),

                    // Schedule Settings (editable)
                    if (state.editedLeague.settings != null) ...[
                      SharedScheduleSection(
                        mode: SettingsMode.edit,
                        settings: state.editedLeague.settings!,
                        onChanged: controller.updateSetting,
                        initiallyExpanded: _expansionStates['schedule'],
                        onExpansionChanged: (isExpanded) => _updateExpansionState('schedule', isExpanded),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Scoring Settings (editable)
                    if (state.editedLeague.scoringSettings != null) ...[
                      SharedScoringSettingsSection(
                        mode: SettingsMode.edit,
                        scoringSettings: state.editedLeague.scoringSettings!,
                        onChanged: controller.updateScoringSetting,
                        initiallyExpanded: _expansionStates['scoring'],
                        onExpansionChanged: (isExpanded) => _updateExpansionState('scoring', isExpanded),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Roster Positions (editable)
                    if (state.editedLeague.rosterPositions != null) ...[
                      SharedRosterPositionsSection(
                        mode: SettingsMode.edit,
                        rosterPositions: state.editedLeague.rosterPositions!,
                        onChanged: controller.updateRosterPosition,
                        initiallyExpanded: _expansionStates['roster_positions'],
                        onExpansionChanged: (isExpanded) => _updateExpansionState('roster_positions', isExpanded),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Waiver Settings (editable)
                    if (state.editedLeague.settings != null) ...[
                      SharedWaiverSettingsSection(
                        mode: SettingsMode.edit,
                        settings: state.editedLeague.settings!,
                        onChanged: controller.updateSetting,
                        initiallyExpanded: _expansionStates['waiver_settings'],
                        onExpansionChanged: (isExpanded) => _updateExpansionState('waiver_settings', isExpanded),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Draft Settings (editable)
                    EditableDraftSettingsSection(
                      leagueId: widget.league.id,
                      rosterPositions: state.editedLeague.rosterPositions,
                      isCommissioner: widget.league.isCommissioner,
                      initiallyExpanded: _expansionStates['draft_settings'],
                      onExpansionChanged: (isExpanded) => _updateExpansionState('draft_settings', isExpanded),
                    ),
                    const SizedBox(height: 16),

                    // Dues & Payouts (editable)
                    if (state.editedLeague.settings != null) ...[
                      EditableDuesPayoutsSection(
                        settings: state.editedLeague.settings!,
                        onChanged: controller.updateSetting,
                        league: widget.league,
                        initiallyExpanded: _expansionStates['dues_payouts'],
                        onExpansionChanged: (isExpanded) => _updateExpansionState('dues_payouts', isExpanded),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Danger Zone (always visible for commissioners)
                    DangerZoneSection(
                      league: widget.league,
                      initiallyExpanded: _expansionStates['danger_zone'],
                      onExpansionChanged: (isExpanded) => _updateExpansionState('danger_zone', isExpanded),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            // Footer with actions
            SettingsFooter(
              league: widget.league,
              expansionStates: _expansionStates,
              hasChanges: state.hasChanges,
              isSubmitting: state.isSubmitting,
              onCancel: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (context) => LeagueSettingsModal(
                    league: widget.league,
                    initialExpansionStates: _expansionStates,
                  ),
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
