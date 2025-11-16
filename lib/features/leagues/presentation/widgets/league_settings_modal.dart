import 'package:flutter/material.dart';
import '../../domain/league.dart';

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
            Container(
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
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Basic Info
                    _buildInfoSection('Basic Information', [
                      _buildInfoRow('Season', league.settings?['season']?.toString() ?? 'N/A'),
                      _buildInfoRow('Season Type', _formatSeasonType(league.settings?['season_type'] as String? ?? 'regular')),
                      _buildInfoRow('Status', _formatStatus(league.status)),
                      _buildInfoRow('Total Teams', '${league.totalRosters}'),
                      _buildInfoRow(
                        'League Type',
                        league.settings?['is_public'] == true ? 'Public' : 'Private',
                      ),
                    ]),
                    const SizedBox(height: 16),

                    // Schedule
                    if (league.settings != null) ...[
                      _buildInfoSection('Schedule', [
                        _buildInfoRow('Start Week', '${league.settings!['start_week'] ?? 'N/A'}'),
                        _buildInfoRow('End Week', '${league.settings!['end_week'] ?? 'N/A'}'),
                        _buildInfoRow(
                          'Playoffs',
                          league.settings!['playoffs_enabled'] == true ? 'Enabled' : 'Disabled',
                        ),
                        if (league.settings!['playoffs_enabled'] == true) ...[
                          _buildInfoRow('Playoff Start', 'Week ${league.settings!['playoff_week_start']}'),
                          _buildInfoRow('Playoff Teams', '${league.settings!['playoff_teams']}'),
                        ],
                      ]),
                      const SizedBox(height: 16),
                    ],

                    // Scoring Settings
                    if (league.scoringSettings != null) ...[
                      _buildScoringSection(league.scoringSettings!),
                      const SizedBox(height: 16),
                    ],

                    // Roster Positions
                    if (league.rosterPositions != null) ...[
                      _buildRosterPositionsSection(league.rosterPositions!),
                      const SizedBox(height: 16),
                    ],

                    // Waiver Settings
                    if (league.settings != null) ...[
                      _buildInfoSection('Waiver Settings', [
                        _buildInfoRow('Waiver Type', _formatWaiverType(league.settings!['waiver_type'])),
                        if (league.settings!['waiver_type'] == 'faab')
                          _buildInfoRow('FAAB Budget', '\$${league.settings!['faab_budget'] ?? 100}'),
                        _buildInfoRow('Waiver Period', '${league.settings!['waiver_period_days'] ?? 2} days'),
                        _buildInfoRow(
                          'Process Schedule',
                          _formatProcessSchedule(league.settings!['process_schedule']),
                        ),
                      ]),
                      const SizedBox(height: 16),
                    ],

                    // Dues & Payouts
                    if (league.settings != null && league.settings!['dues'] != null) ...[
                      _buildDuesPayoutsSection(league.settings!),
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

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: false,
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoringSection(Map<String, dynamic> scoringSettings) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: false,
        title: const Text(
          'Scoring Settings',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Passing',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  'Touchdowns',
                  '${scoringSettings['passing_touchdowns'] ?? 0} pts',
                ),
                _buildInfoRow(
                  'Yards',
                  '${scoringSettings['passing_yards'] ?? 0} pts/yd',
                ),
                const SizedBox(height: 12),
                const Text(
                  'Rushing',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  'Touchdowns',
                  '${scoringSettings['rushing_touchdowns'] ?? 0} pts',
                ),
                _buildInfoRow(
                  'Yards',
                  '${scoringSettings['rushing_yards'] ?? 0} pts/yd',
                ),
                const SizedBox(height: 12),
                const Text(
                  'Receiving',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  'Touchdowns',
                  '${scoringSettings['receiving_touchdowns'] ?? 0} pts',
                ),
                _buildInfoRow(
                  'Yards',
                  '${scoringSettings['receiving_yards'] ?? 0} pts/yd',
                ),
                _buildInfoRow(
                  'Receptions',
                  '${scoringSettings['receiving_receptions'] ?? 0} pts',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRosterPositionsSection(Map<String, dynamic> rosterPositions) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: false,
        title: const Text(
          'Roster Positions',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: rosterPositions.entries
                  .where((e) => (e.value as num) > 0)
                  .map((e) => Chip(
                        label: Text('${e.key}: ${e.value}'),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDuesPayoutsSection(Map<String, dynamic> settings) {
    final dues = (settings['dues'] as num?)?.toDouble() ?? 0.0;
    final payoutStructure = settings['payout_structure'] as List<dynamic>?;

    return Card(
      child: ExpansionTile(
        initiallyExpanded: false,
        title: const Text(
          'Dues & Payouts',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Entry Fee', dues > 0 ? '\$${dues.toStringAsFixed(2)}' : 'Free'),
                if (payoutStructure != null && payoutStructure.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Payout Structure',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...payoutStructure.map((payout) {
                    final payoutMap = payout as Map<String, dynamic>;
                    final type = payoutMap['type'] as String?;
                    final place = payoutMap['place'] as int?;
                    final percentage = (payoutMap['percentage'] as num?)?.toDouble();
                    final amount = (payoutMap['amount'] as num?)?.toDouble();

                    String label = _getPayoutLabel(type, place);
                    String value = '';

                    if (percentage != null) {
                      value = '${percentage.toStringAsFixed(0)}%';
                      if (amount != null) {
                        value += ' (\$${amount.toStringAsFixed(2)})';
                      }
                    } else if (amount != null) {
                      value = '\$${amount.toStringAsFixed(2)}';
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: _buildInfoRow(label, value),
                    );
                  }),
                ],
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

  String _formatWaiverType(dynamic waiverType) {
    if (waiverType == null) return 'N/A';
    switch (waiverType.toString().toLowerCase()) {
      case 'faab':
        return 'FAAB (Free Agent Auction Bidding)';
      case 'rolling':
        return 'Rolling Waivers';
      case 'continual':
        return 'Continual Rolling List';
      default:
        return waiverType.toString();
    }
  }

  String _formatProcessSchedule(dynamic schedule) {
    if (schedule == null) return 'N/A';
    switch (schedule.toString().toLowerCase()) {
      case 'daily':
        return 'Daily';
      case 'weekly':
        return 'Weekly';
      default:
        return schedule.toString();
    }
  }

  String _getPayoutLabel(String? type, int? place) {
    if (type == 'placement') {
      return '${_getOrdinal(place ?? 1)} Place';
    } else if (type == 'placement_points') {
      return '${_getOrdinal(place ?? 1)} Most Points';
    } else if (type == 'highest_weekly_score') {
      return 'Highest Week Score';
    } else if (type == 'regular_season_winner') {
      return 'Regular Season Winner';
    } else if (type == 'highest_points_non_playoff') {
      return 'Highest Points (Non-Playoff)';
    }
    return 'Payout';
  }

  String _getOrdinal(int place) {
    if (place == 1) return '1st';
    if (place == 2) return '2nd';
    if (place == 3) return '3rd';
    return '${place}th';
  }
}
