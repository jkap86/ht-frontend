import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/trade_provider.dart';
import '../../domain/trade.dart';
import 'trade_card.dart';
import 'trade_proposal_dialog.dart';

class TradesTab extends ConsumerWidget {
  final int leagueId;
  final int? userRosterId;
  final bool isCommissioner;

  const TradesTab({
    super.key,
    required this.leagueId,
    this.userRosterId,
    this.isCommissioner = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tradesAsync = ref.watch(tradesNotifierProvider(leagueId));

    return Column(
      children: [
        // Action button
        if (userRosterId != null)
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showProposeTradeDialog(context, ref),
                icon: const Icon(Icons.swap_horiz, size: 18),
                label: const Text('Propose Trade'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

        // Trades list
        Expanded(
          child: tradesAsync.when(
            data: (trades) {
              if (trades.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.swap_horiz,
                        size: 48,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No trades yet',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Sort trades: pending first, then by date
              final sortedTrades = List<Trade>.from(trades)
                ..sort((a, b) {
                  if (a.status == 'pending' && b.status != 'pending') return -1;
                  if (a.status != 'pending' && b.status == 'pending') return 1;
                  return b.proposedAt.compareTo(a.proposedAt);
                });

              return RefreshIndicator(
                onRefresh: () => ref.read(tradesNotifierProvider(leagueId).notifier).refresh(),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: sortedTrades.length,
                  itemBuilder: (context, index) {
                    final trade = sortedTrades[index];
                    return TradeCard(
                      trade: trade,
                      leagueId: leagueId,
                      userRosterId: userRosterId,
                      isCommissioner: isCommissioner,
                    );
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text('Error: $error'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(tradesNotifierProvider(leagueId)),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showProposeTradeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => TradeProposalDialog(
        leagueId: leagueId,
        userRosterId: userRosterId!,
      ),
    );
  }
}
