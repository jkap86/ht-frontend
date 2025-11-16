import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/league.dart';
import '../application/leagues_provider.dart';
import 'widgets/league_settings_modal.dart';

class LeagueDetailsScreen extends ConsumerWidget {
  final int leagueId;

  const LeagueDetailsScreen({
    super.key,
    required this.leagueId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaguesAsync = ref.watch(myLeaguesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('League Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              leaguesAsync.whenData((leagues) {
                final league = leagues.firstWhere(
                  (l) => l.id == leagueId,
                  orElse: () => throw Exception('League not found'),
                );
                showDialog(
                  context: context,
                  builder: (context) => LeagueSettingsModal(league: league),
                );
              });
            },
          ),
        ],
      ),
      body: leaguesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(myLeaguesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (leagues) {
          final league = leagues.firstWhere(
            (l) => l.id == leagueId,
            orElse: () => throw Exception('League not found'),
          );
          return _buildLeagueOverview(context, league);
        },
      ),
    );
  }

  Widget _buildLeagueOverview(BuildContext context, League league) {
    final dues = (league.settings?['dues'] as num?)?.toDouble() ?? 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // League Header Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    league.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildStatusBadge(league.status),
                      _buildInfoChip(
                        Icons.calendar_today,
                        '${league.season} Season',
                      ),
                      _buildInfoChip(
                        Icons.people,
                        '${league.totalRosters} Teams',
                      ),
                      if (dues > 0)
                        _buildInfoChip(
                          Icons.attach_money,
                          '\$${dues.toStringAsFixed(0)} Entry',
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Quick Stats Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Info',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickStat(
                          'League Type',
                          league.settings?['is_public'] == true ? 'Public' : 'Private',
                          Icons.lock_outline,
                        ),
                      ),
                      Expanded(
                        child: _buildQuickStat(
                          'Season Type',
                          _formatSeasonType(league.seasonType),
                          Icons.sports_football,
                        ),
                      ),
                    ],
                  ),
                  if (league.settings != null) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickStat(
                            'Regular Season',
                            'Weeks ${league.settings!['start_week']}-${league.settings!['end_week']}',
                            Icons.event,
                          ),
                        ),
                        if (league.settings!['playoffs_enabled'] == true)
                          Expanded(
                            child: _buildQuickStat(
                              'Playoffs',
                              'Week ${league.settings!['playoff_week_start']} (${league.settings!['playoff_teams']} teams)',
                              Icons.emoji_events,
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Scoring Type Card
          if (league.scoringSettings != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Scoring Type',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildScoringType(context, league.scoringSettings!),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Actions Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: View teams
                        },
                        icon: const Icon(Icons.people),
                        label: const Text('View Teams'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: View matchups
                        },
                        icon: const Icon(Icons.sports),
                        label: const Text('Matchups'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: View standings
                        },
                        icon: const Icon(Icons.leaderboard),
                        label: const Text('Standings'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'pre_draft':
        color = Colors.blue;
        label = 'Pre-Draft';
        icon = Icons.schedule;
        break;
      case 'drafting':
        color = Colors.orange;
        label = 'Drafting';
        icon = Icons.dynamic_feed;
        break;
      case 'in_season':
        color = Colors.green;
        label = 'In Season';
        icon = Icons.play_circle;
        break;
      case 'complete':
        color = Colors.grey;
        label = 'Complete';
        icon = Icons.check_circle;
        break;
      default:
        color = Colors.grey;
        label = status;
        icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
    );
  }

  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildScoringType(BuildContext context, Map<String, dynamic> scoringSettings) {
    final receptions = (scoringSettings['receiving_receptions'] as num?)?.toDouble() ?? 0.0;

    String scoringType;
    String description;

    if (receptions >= 1.0) {
      scoringType = 'Full PPR';
      description = '1 point per reception';
    } else if (receptions >= 0.5) {
      scoringType = 'Half PPR';
      description = '0.5 points per reception';
    } else {
      scoringType = 'Standard';
      description = 'No points for receptions';
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.score,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                scoringType,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatSeasonType(String seasonType) {
    switch (seasonType.toLowerCase()) {
      case 'regular':
        return 'Redraft';
      case 'playoff':
        return 'Playoff';
      case 'dynasty':
        return 'Dynasty';
      default:
        return seasonType;
    }
  }
}
