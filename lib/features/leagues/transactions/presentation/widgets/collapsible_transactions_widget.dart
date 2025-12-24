import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/widgets/collapsible/collapsible_widget.dart';
import '../screens/transactions_screen.dart';

/// Collapsible transactions widget that can be expanded to varying sizes or collapsed to an icon
class CollapsibleTransactionsWidget extends CollapsibleWidget {
  final int leagueId;
  final int? userRosterId;
  final bool isCommissioner;

  const CollapsibleTransactionsWidget({
    super.key,
    required this.leagueId,
    this.userRosterId,
    this.isCommissioner = false,
  }) : super(
          stateKey: 'league_transactions_$leagueId',
          position: CollapsiblePosition.bottomLeft,
          defaultExpandedSize: const Size(700, 500),
          minSize: const Size(400, 300),
        );

  @override
  ConsumerState<CollapsibleTransactionsWidget> createState() =>
      _CollapsibleTransactionsWidgetState();
}

class _CollapsibleTransactionsWidgetState
    extends CollapsibleWidgetState<CollapsibleTransactionsWidget> {
  @override
  Widget buildCollapsedIcon(BuildContext context) {
    return InkWell(
      onTap: toggleExpanded,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: widget.collapsedSize,
        height: widget.collapsedSize,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Icon(
            Icons.swap_horiz,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }

  @override
  Widget buildExpandedContent(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(16),
      ),
      child: TransactionsScreen(
        leagueId: widget.leagueId,
        userRosterId: widget.userRosterId,
        isCommissioner: widget.isCommissioner,
      ),
    );
  }

  @override
  Widget? buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.swap_horiz, size: 18),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Transactions',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: toggleExpanded,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
