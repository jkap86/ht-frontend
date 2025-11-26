import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/league.dart';
import '../../domain/draft.dart';
import '../../application/drafts_provider.dart';
import 'banners/banners.dart';
import 'derby/derby_views.dart';
import 'commissioner_action_buttons.dart';
import 'normal_draft_order_list.dart';

/// Widget that displays draft order content including derby UI
class DraftOrderContentWidget extends ConsumerWidget {
  final Draft draft;
  final int leagueId;
  final bool isCommissioner;
  final League league;

  const DraftOrderContentWidget({
    super.key,
    required this.draft,
    required this.leagueId,
    required this.isCommissioner,
    required this.league,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = draft.settings;
    final draftOrder = settings?.draftOrder ?? 'randomize';
    final draftId = draft.id;

    // Parse derby times and status
    final derbyStartTime = settings?.derbyStartTime;
    final derbyStatus = settings?.derbyStatus;
    final pickDeadline = draft.pickDeadline;

    // Watch the draft order provider
    final draftOrderState = ref.watch(
        draftOrderProvider((leagueId: leagueId, draftId: draftId)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Derby countdown or notification (shown when derby order is selected)
        if (draftOrder.toLowerCase() == 'derby') ...[
          // If derby is in progress, show pick timer
          if (derbyStatus == 'in_progress' && pickDeadline != null)
            PickTimerBanner(pickDeadline: pickDeadline)
          // If derby hasn't started yet, show start countdown
          else if (derbyStartTime != null && derbyStatus != 'completed' && derbyStatus != 'in_progress')
            StartCountdownBanner(derbyStartTime: derbyStartTime)
          else if (derbyStatus != 'completed' && derbyStatus != 'in_progress')
            const NoStartTimeBanner(),
        ],

        // Commissioner action buttons (Randomize/Start Derby)
        CommissionerActionButtons(
          leagueId: leagueId,
          draftId: draftId,
          isCommissioner: isCommissioner,
          derbyStatus: derbyStatus,
          draftOrder: draftOrder,
        ),
        // Draft order list or slot selection
        draftOrderState.when(
          data: (order) {
            if (order.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Click the button above to randomize draft order',
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              );
            }

            // If derby is in progress or paused, show slot selection UI
            if ((derbyStatus == 'in_progress' || derbyStatus == 'paused') &&
                draftOrder.toLowerCase() == 'derby') {
              return DerbyInProgressView(
                leagueId: leagueId,
                draftId: draftId,
                order: order,
                settings: settings,
                isCommissioner: isCommissioner,
              );
            }

            // If derby is completed, show final order sorted by derby slots
            if (draftOrder.toLowerCase() == 'derby' &&
                derbyStatus == 'completed' &&
                order.isNotEmpty) {
              return DerbyCompletedView(
                order: order,
                league: league,
                draft: draft,
              );
            }

            // If derby is randomized but not started, show picking order
            if (draftOrder.toLowerCase() == 'derby' &&
                order.isNotEmpty &&
                derbyStatus != 'in_progress' &&
                derbyStatus != 'paused' &&
                derbyStatus != 'completed') {
              return DerbyPickingOrderView(order: order);
            }

            // Normal draft order display
            return NormalDraftOrderList(order: order);
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Error loading draft order: $error',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ),
        ),

        // Draft Board button - always visible in expanded section
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
            icon: const Icon(Icons.dashboard),
            label: const Text('Draft Board'),
          ),
        ),
      ],
    );
  }
}
