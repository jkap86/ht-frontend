import 'package:flutter/material.dart';
import '../../domain/league.dart';
import 'league_settings_sections/basic_info_section.dart';
import '../../dues_payouts/presentation/widgets/dues_payouts_section.dart';
import '../../drafts/presentation/widgets/draft_settings_section.dart';
import 'league_settings_sections/danger_zone_section.dart';
import '../../../../shared/models/settings_mode.dart';
import '../../../../shared/widgets/settings/shared_schedule_section.dart';
import '../../../../shared/widgets/settings/shared_scoring_settings_section.dart';
import '../../../../shared/widgets/settings/shared_roster_positions_section.dart';
import '../../../../shared/widgets/settings/shared_waiver_settings_section.dart';
import 'edit_league_settings_modal.dart';

/// League settings modal - displays all league configuration
class LeagueSettingsModal extends StatelessWidget {
  final League league;

  const LeagueSettingsModal({
    super.key,
    required this.league,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
        child: Column(
          children: [
            // Header
            _SettingsHeader(
              league: league,
              onClose: () => Navigator.of(context).pop(),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Basic Info
                    BasicInfoSection(league: league),
                    const SizedBox(height: 16),

                    // Schedule
                    if (league.settings != null) ...[
                      SharedScheduleSection(
                        mode: SettingsMode.view,
                        settings: league.settings!,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Scoring Settings
                    if (league.scoringSettings != null) ...[
                      SharedScoringSettingsSection(
                        mode: SettingsMode.view,
                        scoringSettings: league.scoringSettings!,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Roster Positions
                    if (league.rosterPositions != null) ...[
                      SharedRosterPositionsSection(
                        mode: SettingsMode.view,
                        rosterPositions: league.rosterPositions!,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Waiver Settings
                    if (league.settings != null) ...[
                      SharedWaiverSettingsSection(
                        mode: SettingsMode.view,
                        settings: league.settings!,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Draft Settings
                    DraftSettingsSection(league: league),
                    const SizedBox(height: 16),

                    // Dues & Payouts
                    if (league.settings != null &&
                        league.settings!['dues'] != null) ...[
                      DuesPayoutsSection(settings: league.settings!),
                      const SizedBox(height: 16),
                    ],

                    // Danger Zone (only for commissioners)
                    if (league.isCommissioner) ...[
                      DangerZoneSection(league: league),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Settings modal header
class _SettingsHeader extends StatelessWidget {
  final League league;
  final VoidCallback onClose;

  const _SettingsHeader({
    required this.league,
    required this.onClose,
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
          const Icon(Icons.settings, color: Colors.white),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'League Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          // Edit button (only for commissioners)
          if (league.isCommissioner) ...[
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                // Close current modal and open edit modal
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (context) => EditLeagueSettingsModal(league: league),
                );
              },
            ),
          ],
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}
