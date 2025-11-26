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
class LeagueSettingsModal extends StatefulWidget {
  final League league;
  final Map<String, bool>? initialExpansionStates;

  const LeagueSettingsModal({
    super.key,
    required this.league,
    this.initialExpansionStates,
  });

  @override
  State<LeagueSettingsModal> createState() => _LeagueSettingsModalState();
}

class _LeagueSettingsModalState extends State<LeagueSettingsModal> {
  late Map<String, bool> _expansionStates;

  @override
  void initState() {
    super.initState();
    // Initialize expansion states with provided values or defaults
    _expansionStates = {
      'basic_info': widget.initialExpansionStates?['basic_info'] ?? false,
      'schedule': widget.initialExpansionStates?['schedule'] ?? false,
      'scoring': widget.initialExpansionStates?['scoring'] ?? false,
      'roster_positions': widget.initialExpansionStates?['roster_positions'] ?? false,
      'waiver_settings': widget.initialExpansionStates?['waiver_settings'] ?? false,
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
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
        child: Column(
          children: [
            // Header
            _SettingsHeader(
              league: widget.league,
              expansionStates: _expansionStates,
              onClose: () => Navigator.of(context).pop(),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // League Name Display
                    Center(
                      child: Text(
                        widget.league.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Basic Info
                    BasicInfoSection(
                      league: widget.league,
                      initiallyExpanded: _expansionStates['basic_info'],
                      onExpansionChanged: (isExpanded) => _updateExpansionState('basic_info', isExpanded),
                    ),
                    const SizedBox(height: 16),

                    // Schedule
                    if (widget.league.settings != null) ...[
                      SharedScheduleSection(
                        mode: SettingsMode.view,
                        settings: widget.league.settings!,
                        initiallyExpanded: _expansionStates['schedule'],
                        onExpansionChanged: (isExpanded) => _updateExpansionState('schedule', isExpanded),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Scoring Settings
                    if (widget.league.scoringSettings != null) ...[
                      SharedScoringSettingsSection(
                        mode: SettingsMode.view,
                        scoringSettings: widget.league.scoringSettings!,
                        initiallyExpanded: _expansionStates['scoring'],
                        onExpansionChanged: (isExpanded) => _updateExpansionState('scoring', isExpanded),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Roster Positions
                    if (widget.league.rosterPositions != null) ...[
                      SharedRosterPositionsSection(
                        mode: SettingsMode.view,
                        rosterPositions: widget.league.rosterPositions!,
                        initiallyExpanded: _expansionStates['roster_positions'],
                        onExpansionChanged: (isExpanded) => _updateExpansionState('roster_positions', isExpanded),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Waiver Settings
                    if (widget.league.settings != null) ...[
                      SharedWaiverSettingsSection(
                        mode: SettingsMode.view,
                        settings: widget.league.settings!,
                        initiallyExpanded: _expansionStates['waiver_settings'],
                        onExpansionChanged: (isExpanded) => _updateExpansionState('waiver_settings', isExpanded),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Draft Settings
                    DraftSettingsSection(
                      league: widget.league,
                      initiallyExpanded: _expansionStates['draft_settings'],
                      onExpansionChanged: (isExpanded) => _updateExpansionState('draft_settings', isExpanded),
                    ),
                    const SizedBox(height: 16),

                    // Dues & Payouts
                    if (widget.league.settings != null &&
                        widget.league.settings!['dues'] != null) ...[
                      DuesPayoutsSection(
                        settings: widget.league.settings!,
                        initiallyExpanded: _expansionStates['dues_payouts'],
                        onExpansionChanged: (isExpanded) => _updateExpansionState('dues_payouts', isExpanded),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Danger Zone (only for commissioners)
                    if (widget.league.isCommissioner) ...[
                      DangerZoneSection(
                        league: widget.league,
                        initiallyExpanded: _expansionStates['danger_zone'],
                        onExpansionChanged: (isExpanded) => _updateExpansionState('danger_zone', isExpanded),
                      ),
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
  final Map<String, bool> expansionStates;
  final VoidCallback onClose;

  const _SettingsHeader({
    required this.league,
    required this.expansionStates,
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
                // Close current modal and open edit modal with expansion states
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (context) => EditLeagueSettingsModal(
                    league: league,
                    initialExpansionStates: expansionStates,
                  ),
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
