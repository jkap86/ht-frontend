import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../application/create_league_controller.dart';
import '../../../../leagues/application/leagues_provider.dart';
import '../league_form/dues_payouts_section.dart';
import 'basic_settings_section.dart';
import 'create_draft_settings_section.dart';
import 'scoring_settings_section.dart';
import 'roster_positions_section.dart';
import 'waiver_settings_section.dart';
import 'trade_settings_section.dart';

/// Simplified create league form using dumb widgets and controller
/// This widget is just composition - all logic is in the controller
class CreateLeagueForm extends ConsumerWidget {
  const CreateLeagueForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createLeagueControllerProvider);
    final controller = ref.read(createLeagueControllerProvider.notifier);

    // Listen for success and navigate to league
    ref.listen(createLeagueControllerProvider, (previous, next) async {
      if (next.isSuccess && !next.isSubmitting) {
        // Get the newly created league from the leagues list
        final leagues = ref.read(myLeaguesProvider).valueOrNull ?? [];
        if (leagues.isNotEmpty) {
          final newLeague = leagues.first; // The newest league is at the top

          // Close the modal
          Navigator.of(context).pop();

          // Navigate to the league details screen
          context.go('/league/${newLeague.id}');
        }
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Public/Private Toggle
          Card(
            child: SwitchListTile(
              title: Text(state.data.isPublic ? 'Public League' : 'Private League'),
              subtitle: Text(
                state.data.isPublic
                    ? 'Anyone can find and join this league'
                    : 'Private - Invite only',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              value: state.data.isPublic,
              onChanged: controller.updateIsPublic,
              secondary: Icon(state.data.isPublic ? Icons.public : Icons.lock),
            ),
          ),
          const SizedBox(height: 16),

          // Basic Settings Section - dumb widget
          BasicSettingsSection(
            data: state.data,
            onNameChanged: controller.updateName,
            onSeasonChanged: controller.updateSeason,
            onTotalRostersChanged: controller.updateTotalRosters,
            onSeasonTypeChanged: controller.updateSeasonType,
            onStartWeekChanged: controller.updateStartWeek,
            onEndWeekChanged: controller.updateEndWeek,
            onPlayoffsEnabledChanged: controller.updatePlayoffsEnabled,
            onPlayoffWeekStartChanged: controller.updatePlayoffWeekStart,
            onPlayoffTeamsChanged: controller.updatePlayoffTeams,
            nameError: state.error?.contains('name') == true ? state.error : null,
            seasonError: state.error?.contains('season') == true ? state.error : null,
          ),
          const SizedBox(height: 16),

          // Draft Settings Section - with local state management
          CreateDraftSettingsSection(
            data: state.data,
            onDraftConfigurationsChanged: controller.updateDraftConfigurations,
            rosterPositions: state.data.rosterPositions,
          ),
          const SizedBox(height: 16),

          // Scoring Settings Section - dumb widget
          ScoringSettingsSection(
            scoringSettings: state.data.scoringSettings,
            onChanged: controller.updateScoringSettings,
          ),
          const SizedBox(height: 16),

          // Roster Positions Section - dumb widget
          RosterPositionsSection(
            rosterPositions: state.data.rosterPositions,
            onChanged: controller.updateRosterPositions,
          ),
          const SizedBox(height: 16),

          // Waiver Settings Section - dumb widget
          WaiverSettingsSection(
            data: state.data,
            onWaiverTypeChanged: controller.updateWaiverType,
            onFaabBudgetChanged: controller.updateFaabBudget,
            onWaiverPeriodDaysChanged: controller.updateWaiverPeriodDays,
            onProcessScheduleChanged: controller.updateProcessSchedule,
          ),
          const SizedBox(height: 16),

          // Trade Settings Section - dumb widget
          TradeSettingsSection(
            data: state.data,
            onTradeNotificationChanged: controller.updateTradeNotificationSetting,
            onTradeDetailsChanged: controller.updateTradeDetailsSetting,
          ),
          const SizedBox(height: 16),

          // Dues/Payouts Section - existing widget (to be refactored later)
          DuesPayoutsSection(
            entryFee: state.data.entryFee,
            payoutStructure: state.data.payoutStructure,
            onEntryFeeChanged: controller.updateEntryFee,
            onPayoutStructureChanged: controller.updatePayoutStructure,
            totalRosters: state.data.totalRosters,
          ),
          const SizedBox(height: 24),

          // Error display
          if (state.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    state.error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ),
            ),

          // Create Button
          FilledButton.icon(
            onPressed: state.isSubmitting ? null : controller.submitForm,
            icon: state.isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.add),
            label: Text(state.isSubmitting ? 'Creating...' : 'Create League'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
