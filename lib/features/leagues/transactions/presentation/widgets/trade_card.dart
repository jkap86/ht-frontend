import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../application/trade_provider.dart';
import '../../domain/trade.dart';

class TradeCard extends ConsumerWidget {
  final Trade trade;
  final int leagueId;
  final int? userRosterId;
  final bool isCommissioner;

  const TradeCard({
    super.key,
    required this.trade,
    required this.leagueId,
    this.userRosterId,
    this.isCommissioner = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isProposer = userRosterId == trade.proposerRosterId;
    final isRecipient = userRosterId == trade.recipientRosterId;
    final isPending = trade.status == 'pending';

    // Get items for each side
    final proposerItems = trade.items.where((i) => i.fromRosterId == trade.proposerRosterId).toList();
    final recipientItems = trade.items.where((i) => i.fromRosterId == trade.recipientRosterId).toList();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              children: [
                _buildStatusChip(context),
                const Spacer(),
                Text(
                  DateFormat('MMM d, h:mm a').format(trade.proposedAt),
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Trade parties
            Row(
              children: [
                Expanded(
                  child: _buildTradeSide(
                    context,
                    trade.proposerUsername ?? 'Team ${trade.proposerRosterNumber ?? trade.proposerRosterId}',
                    proposerItems,
                    isProposer,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.swap_horiz,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                Expanded(
                  child: _buildTradeSide(
                    context,
                    trade.recipientUsername ?? 'Team ${trade.recipientRosterNumber ?? trade.recipientRosterId}',
                    recipientItems,
                    isRecipient,
                  ),
                ),
              ],
            ),

            // Notes
            if (trade.notes != null && trade.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.notes,
                      size: 14,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        trade.notes!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Action buttons
            if (isPending) ...[
              const SizedBox(height: 12),
              _buildActionButtons(context, ref, isProposer, isRecipient),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    final (color, text) = switch (trade.status) {
      'pending' => (Colors.orange, 'Pending'),
      'accepted' => (Colors.green, 'Accepted'),
      'rejected' => (Colors.red, 'Rejected'),
      'cancelled' => (Colors.grey, 'Cancelled'),
      'vetoed' => (Colors.purple, 'Vetoed'),
      _ => (Colors.grey, trade.status),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTradeSide(
    BuildContext context,
    String teamName,
    List<TradeItem> items,
    bool isCurrentUser,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (isCurrentUser)
              const Icon(Icons.person, size: 14, color: Colors.blue),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                teamName,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: isCurrentUser
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items.isEmpty
                ? [
                    Text(
                      'No players',
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.outline,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ]
                : items
                    .map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: _getPositionColor(item.playerPosition).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item.playerPosition ?? '?',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: _getPositionColor(item.playerPosition),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  item.playerName ?? 'Unknown',
                                  style: const TextStyle(fontSize: 11),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    bool isProposer,
    bool isRecipient,
  ) {
    final notifier = ref.read(tradesNotifierProvider(leagueId).notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Cancel (proposer only)
        if (isProposer)
          TextButton.icon(
            onPressed: () => _confirmAction(
              context,
              'Cancel Trade',
              'Are you sure you want to cancel this trade?',
              () => notifier.cancelTrade(trade.id),
            ),
            icon: const Icon(Icons.close, size: 16),
            label: const Text('Cancel', style: TextStyle(fontSize: 12)),
            style: TextButton.styleFrom(foregroundColor: Colors.grey),
          ),

        // Reject (recipient only)
        if (isRecipient)
          TextButton.icon(
            onPressed: () => _confirmAction(
              context,
              'Reject Trade',
              'Are you sure you want to reject this trade?',
              () => notifier.rejectTrade(trade.id),
            ),
            icon: const Icon(Icons.thumb_down, size: 16),
            label: const Text('Reject', style: TextStyle(fontSize: 12)),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),

        // Accept (recipient only)
        if (isRecipient) ...[
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () => _confirmAction(
              context,
              'Accept Trade',
              'Are you sure you want to accept this trade?',
              () => notifier.acceptTrade(trade.id),
            ),
            icon: const Icon(Icons.thumb_up, size: 16),
            label: const Text('Accept', style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],

        // Veto (commissioner only)
        if (isCommissioner && !isProposer && !isRecipient)
          TextButton.icon(
            onPressed: () => _confirmAction(
              context,
              'Veto Trade',
              'Are you sure you want to veto this trade as commissioner?',
              () => notifier.vetoTrade(trade.id),
            ),
            icon: const Icon(Icons.gavel, size: 16),
            label: const Text('Veto', style: TextStyle(fontSize: 12)),
            style: TextButton.styleFrom(foregroundColor: Colors.purple),
          ),
      ],
    );
  }

  void _confirmAction(
    BuildContext context,
    String title,
    String message,
    Future<void> Function() action,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await action();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Trade updated successfully')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Color _getPositionColor(String? position) {
    switch (position?.toUpperCase()) {
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
