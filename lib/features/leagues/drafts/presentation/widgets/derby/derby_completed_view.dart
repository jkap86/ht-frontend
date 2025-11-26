import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/league.dart';
import '../../../domain/draft.dart';

/// Widget that displays the final derby results with sortable columns
class DerbyCompletedView extends StatelessWidget {
  final List<Map<String, dynamic>> order;
  final League league;
  final Draft draft;

  const DerbyCompletedView({
    super.key,
    required this.order,
    required this.league,
    required this.draft,
  });

  @override
  Widget build(BuildContext context) {
    bool sortByDraftOrder = true; // Closure variable

    return StatefulBuilder(
      builder: (context, setBuilderState) {
        // Create a map of original picking order (index + 1) for each user
        final pickingOrderMap = <String, int>{};
        for (int i = 0; i < order.length; i++) {
          final rosterId = order[i]['rosterId']?.toString() ?? '';
          if (rosterId.isNotEmpty) {
            pickingOrderMap[rosterId] = i + 1;
          }
        }

        // Sort based on selected option
        final sortedOrder = List<Map<String, dynamic>>.from(order);
        if (sortByDraftOrder) {
          // Sort by draft order (draft_position)
          sortedOrder.sort((a, b) {
            final posA = (a['draftPosition'] as int?) ?? 999;
            final posB = (b['draftPosition'] as int?) ?? 999;
            return posA.compareTo(posB);
          });
        } else {
          // Sort by derby slot (original picking order)
          sortedOrder.sort((a, b) {
            final rosterIdA = a['rosterId']?.toString() ?? '';
            final rosterIdB = b['rosterId']?.toString() ?? '';
            final derbySlotA = pickingOrderMap[rosterIdA] ?? 999;
            final derbySlotB = pickingOrderMap[rosterIdB] ?? 999;
            return derbySlotA.compareTo(derbySlotB);
          });
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Final Draft Order',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Header row
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: InkWell(
                            onTap: () {
                              setBuilderState(() {
                                sortByDraftOrder = false;
                              });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Derby Slot',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: !sortByDraftOrder
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                  ),
                                ),
                                if (!sortByDraftOrder)
                                  Icon(
                                    Icons.arrow_drop_down,
                                    size: 16,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Team',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: InkWell(
                            onTap: () {
                              setBuilderState(() {
                                sortByDraftOrder = true;
                              });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Draft Order',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: sortByDraftOrder
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                  ),
                                ),
                                if (sortByDraftOrder)
                                  Icon(
                                    Icons.arrow_drop_down,
                                    size: 16,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  ...sortedOrder.map((item) {
                    final draftSlot = item['draftPosition'] as int?;
                    final rosterId = item['rosterId']?.toString() ?? '';
                    final derbySlot = pickingOrderMap[rosterId];
                    final username = item['username'] as String? ??
                        'Team ${item['rosterId']}';

                    if (draftSlot == null) return const SizedBox.shrink();

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 80,
                            child: Text(
                              derbySlot != null ? '#$derbySlot' : '-',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                username,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Slot $draftSlot',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            // Draft Room button
            const SizedBox(height: 16),
            Center(
              child: FilledButton.icon(
                onPressed: () {
                  context.goNamed(
                    'draft-room',
                    pathParameters: {
                      'leagueId': league.id.toString(),
                      'draftId': draft.id.toString(),
                    },
                  );
                },
                icon: const Icon(Icons.meeting_room),
                label: const Text('Enter Draft Room'),
              ),
            ),
          ],
        );
      },
    );
  }
}
