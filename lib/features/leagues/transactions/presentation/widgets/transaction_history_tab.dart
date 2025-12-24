import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../application/waiver_provider.dart';
import '../../domain/waiver_claim.dart';

class TransactionHistoryTab extends ConsumerWidget {
  final int leagueId;

  const TransactionHistoryTab({
    super.key,
    required this.leagueId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(
      transactionHistoryProvider((leagueId: leagueId, limit: 50)),
    );

    return historyAsync.when(
      data: (transactions) {
        if (transactions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 48,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 12),
                Text(
                  'No transaction history',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        // Group transactions by date
        final groupedTransactions = <String, List<RosterTransaction>>{};
        for (final tx in transactions) {
          final dateKey = DateFormat('MMM d, yyyy').format(tx.createdAt);
          groupedTransactions.putIfAbsent(dateKey, () => []).add(tx);
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(transactionHistoryProvider((leagueId: leagueId, limit: 50)));
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: groupedTransactions.length,
            itemBuilder: (context, index) {
              final dateKey = groupedTransactions.keys.elementAt(index);
              final dayTransactions = groupedTransactions[dateKey]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date header
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      dateKey,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                  // Transactions for this date
                  ...dayTransactions.map((tx) => _buildTransactionTile(context, tx)),
                ],
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
              onPressed: () => ref.invalidate(
                transactionHistoryProvider((leagueId: leagueId, limit: 50)),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTile(BuildContext context, RosterTransaction tx) {
    final (icon, color, actionText) = _getTransactionDisplay(tx);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        tx.rosterUsername ?? 'Unknown',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        actionText,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (tx.playerPosition != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: _getPositionColor(tx.playerPosition!).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            tx.playerPosition!,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: _getPositionColor(tx.playerPosition!),
                            ),
                          ),
                        ),
                      Flexible(
                        child: Text(
                          tx.playerName ?? 'Unknown Player',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Time
            Text(
              DateFormat('h:mm a').format(tx.createdAt),
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  (IconData, Color, String) _getTransactionDisplay(RosterTransaction tx) {
    switch (tx.transactionType.toLowerCase()) {
      case 'trade':
        return (
          tx.acquired ? Icons.call_received : Icons.call_made,
          Colors.purple,
          tx.acquired ? 'received via trade' : 'sent via trade'
        );
      case 'waiver':
        return (
          tx.acquired ? Icons.add_circle : Icons.remove_circle,
          Colors.blue,
          tx.acquired ? 'claimed off waivers' : 'dropped'
        );
      case 'free_agent':
        return (
          tx.acquired ? Icons.person_add : Icons.person_remove,
          Colors.green,
          tx.acquired ? 'added from FA' : 'dropped'
        );
      case 'draft':
        return (Icons.sports_football, Colors.orange, 'drafted');
      default:
        return (
          tx.acquired ? Icons.add : Icons.remove,
          Colors.grey,
          tx.acquired ? 'added' : 'removed'
        );
    }
  }

  Color _getPositionColor(String position) {
    switch (position.toUpperCase()) {
      case 'QB':
        return Colors.red;
      case 'RB':
        return Colors.green;
      case 'WR':
        return Colors.blue;
      case 'TE':
        return Colors.orange;
      case 'K':
        return Colors.teal;
      case 'DEF':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }
}
