import 'package:flutter/material.dart';
import '../../domain/league.dart';
import 'league_settings_sections/basic_info_section.dart';
import 'league_settings_sections/schedule_section.dart';
import 'league_settings_sections/scoring_settings_section.dart';
import 'league_settings_sections/roster_positions_section.dart';
import 'league_settings_sections/waiver_settings_section.dart';
import 'league_settings_sections/dues_payouts_section.dart';
import 'league_settings_sections/danger_zone_section.dart';

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
                      ScheduleSection(settings: league.settings!),
                      const SizedBox(height: 16),
                    ],

                    // Scoring Settings
                    if (league.scoringSettings != null) ...[
                      ScoringSettingsSection(
                        scoringSettings: league.scoringSettings!,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Roster Positions
                    if (league.rosterPositions != null) ...[
                      RosterPositionsSection(
                        rosterPositions: league.rosterPositions!,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Waiver Settings
                    if (league.settings != null) ...[
                      WaiverSettingsSection(settings: league.settings!),
                      const SizedBox(height: 16),
                    ],

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
  final VoidCallback onClose;

  const _SettingsHeader({required this.onClose});

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
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}
