import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/league.dart';
import '../application/leagues_provider.dart';
import 'widgets/league_settings_modal.dart';
import 'widgets/league_header_card.dart';
import 'widgets/league_buyin_card.dart';
import 'widgets/league_workflow_widget.dart';
import 'widgets/matchups_overview_card.dart';
import '../dues_payouts/presentation/widgets/dues_overview_card.dart';
import '../drafts/presentation/widgets/draft_overview_card.dart';
import '../drafts/application/drafts_provider.dart';
import '../chat/presentation/widgets/collapsible_chat_widget.dart';
import 'widgets/developer_tools_widget.dart';
import '../dues_payouts/application/league_members_provider.dart';

class LeagueDetailsScreen extends ConsumerStatefulWidget {
  final int leagueId;
  final String? initialStep;

  const LeagueDetailsScreen({
    super.key,
    required this.leagueId,
    this.initialStep,
  });

  @override
  ConsumerState<LeagueDetailsScreen> createState() => _LeagueDetailsScreenState();
}

class _LeagueDetailsScreenState extends ConsumerState<LeagueDetailsScreen> {
  String? _selectedStep;

  @override
  void initState() {
    super.initState();
    // Set initial step if provided
    if (widget.initialStep != null) {
      _selectedStep = widget.initialStep;
    }
  }

  @override
  Widget build(BuildContext context) {
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
          (l) => l.id == widget.leagueId,
          orElse: () => throw Exception('League not found'),
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(league.name),
            actions: [
              // Settings button - always shows read-only modal
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => LeagueSettingsModal(league: league),
                  );
                },
              ),
            ],
          ),
          body: SizedBox.expand(
            child: Stack(
              children: [
                _buildLeagueOverview(context, league, ref),
                CollapsibleChatWidget(leagueId: widget.leagueId),
                DeveloperToolsWidget(leagueId: widget.leagueId),
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

  Widget _buildLeagueOverview(BuildContext context, League league, WidgetRef ref) {
    final dues = (league.settings?['dues'] as num?)?.toDouble() ?? 0.0;
    final membersAsync = ref.watch(leagueMembersProvider(league.id));
    final draftsAsync = ref.watch(leagueDraftsProvider(league.id));

    // Determine default workflow step based on league state
    String defaultStep = 'Dues';
    membersAsync.whenData((members) {
      if (members.isNotEmpty) {
        final allPaid = members.every((m) => m.paid);
        final leagueFull = members.length >= league.totalRosters;
        if (leagueFull && allPaid) {
          defaultStep = 'Draft';
        }
      }
    });

    // Check if all drafts are completed, if so, default to Matchups
    draftsAsync.whenData((drafts) {
      if (drafts.isNotEmpty) {
        final allDraftsCompleted = drafts.every((draft) => draft.status == 'completed');
        if (allDraftsCompleted) {
          defaultStep = 'Matchups';
        }
      }
    });

    // Use selected step if set, otherwise use default
    final selectedStep = _selectedStep ?? defaultStep;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // League Header Card - extracted component
          LeagueHeaderCard(league: league),
          const SizedBox(height: 16),

          // Workflow steps
          LeagueWorkflowWidget(
            league: league,
            onStepSelected: (step) {
              setState(() {
                _selectedStep = step;
              });
            },
          ),
          const SizedBox(height: 16),

          // Conditional content based on selected workflow step
          if (selectedStep == 'Dues') ...[
            DuesOverviewCard(league: league),
          ] else if (selectedStep == 'Draft') ...[
            DraftOverviewCard(league: league),
          ] else if (selectedStep == 'Matchups') ...[
            MatchupsOverviewCard(league: league),
          ] else if (dues > 0) ...[
            // Buy-In / Payouts Card - shown for other steps if dues exist
            LeagueBuyInCard(league: league, dues: dues),
          ],
        ],
      ),
    );
  }
}
