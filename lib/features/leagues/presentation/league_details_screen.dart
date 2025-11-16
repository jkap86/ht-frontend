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

          // Buy-In / Payouts Card
          if (dues > 0) _buildBuyInCard(league, dues),
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

  Widget _buildBuyInCard(League league, double dues) {
    final totalPot = dues * league.totalRosters;
    final payoutStructure = league.settings?['payout_structure'] as List<dynamic>?;

    return Card(
      child: ExpansionTile(
        initiallyExpanded: false,
        leading: const Icon(Icons.attach_money),
        title: Text(
          'Buy-In: \$${dues.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text('Total Pot: \$${totalPot.toStringAsFixed(2)}'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (payoutStructure != null && payoutStructure.isNotEmpty) ...[
                  const Text(
                    'Payout Structure',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
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
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(label),
                          Text(
                            value,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    );
                  }),
                ] else
                  const Text(
                    'No payout structure configured',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
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
