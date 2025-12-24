import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/trades_tab.dart';
import '../widgets/waivers_tab.dart';
import '../widgets/free_agents_tab.dart';
import '../widgets/transaction_history_tab.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  final int leagueId;
  final int? userRosterId;
  final bool isCommissioner;

  const TransactionsScreen({
    super.key,
    required this.leagueId,
    this.userRosterId,
    this.isCommissioner = false,
  });

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab bar
        Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
            indicatorColor: Theme.of(context).colorScheme.primary,
            labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            tabs: const [
              Tab(text: 'Trades'),
              Tab(text: 'Waivers'),
              Tab(text: 'Free Agents'),
              Tab(text: 'History'),
            ],
          ),
        ),

        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              TradesTab(
                leagueId: widget.leagueId,
                userRosterId: widget.userRosterId,
                isCommissioner: widget.isCommissioner,
              ),
              WaiversTab(
                leagueId: widget.leagueId,
                userRosterId: widget.userRosterId,
              ),
              FreeAgentsTab(
                leagueId: widget.leagueId,
                userRosterId: widget.userRosterId,
              ),
              TransactionHistoryTab(
                leagueId: widget.leagueId,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
