import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/league.dart';
import '../application/leagues_provider.dart';
import 'widgets/league_settings_modal.dart';
import 'widgets/edit_league_settings_modal.dart';
import 'widgets/league_header_card.dart';
import 'widgets/league_buyin_card.dart';
import 'widgets/collapsible_chat_widget.dart';

class LeagueDetailsScreen extends ConsumerWidget {
  final int leagueId;

  const LeagueDetailsScreen({
    super.key,
    required this.leagueId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaguesAsync = ref.watch(myLeaguesProvider);

    return leaguesAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('League Details')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('League Details')),
        body: _buildError(error, ref),
      ),
      data: (leagues) {
        final league = leagues.firstWhere(
          (l) => l.id == leagueId,
          orElse: () => throw Exception('League not found'),
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('League Details'),
            actions: [
              // Settings button - editable for commissioners, read-only for others
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => league.isCommissioner
                        ? EditLeagueSettingsModal(league: league)
                        : LeagueSettingsModal(league: league),
                  );
                },
              ),
            ],
          ),
          body: SizedBox.expand(
            child: Stack(
              children: [
                _buildLeagueOverview(context, league),
                CollapsibleChatWidget(leagueId: leagueId),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildError(Object error, WidgetRef ref) {
    return Center(
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
