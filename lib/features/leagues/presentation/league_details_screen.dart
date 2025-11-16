import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/league.dart';
import '../application/leagues_provider.dart';
import 'widgets/league_settings_modal.dart';
import 'widgets/league_header_card.dart';
import 'widgets/league_buyin_card.dart';

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
          // League Header Card - extracted component
          LeagueHeaderCard(league: league),
          const SizedBox(height: 16),

          // Buy-In / Payouts Card - extracted component
          if (dues > 0) LeagueBuyInCard(league: league, dues: dues),
        ],
      ),
    );
  }
}
