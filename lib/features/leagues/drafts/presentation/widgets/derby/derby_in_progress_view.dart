import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/drafts_provider.dart';
import '../../../../../auth/application/auth_notifier.dart';
import 'derby_pick_order_list.dart';
import 'derby_status_banner.dart';
import 'derby_control_buttons.dart';
import 'derby_slot_grid.dart';

/// Widget that displays the derby UI when the derby is in progress
class DerbyInProgressView extends ConsumerStatefulWidget {
  final int leagueId;
  final int draftId;
  final List<Map<String, dynamic>> order;
  final dynamic settings;
  final bool isCommissioner;

  const DerbyInProgressView({
    super.key,
    required this.leagueId,
    required this.draftId,
    required this.order,
    required this.settings,
    required this.isCommissioner,
  });

  @override
  ConsumerState<DerbyInProgressView> createState() => _DerbyInProgressViewState();
}

class _DerbyInProgressViewState extends ConsumerState<DerbyInProgressView> {
  @override
  Widget build(BuildContext context) {
    final currentPickerIndex = widget.settings?.currentPickerIndex ?? 0;

    // Validate that currentPickerIndex is within bounds
    if (widget.order.isEmpty || currentPickerIndex >= widget.order.length) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Invalid draft state. Please refresh.'),
      );
    }

    final currentPicker = widget.order[currentPickerIndex];
    final currentPickerUserId = currentPicker['userId']?.toString();

    // Get current user's ID to check if it's their turn
    final authState = ref.watch(authProvider);
    final currentUserId = authState.user?.userId;
    final isMyTurn =
        currentUserId != null && currentPickerUserId == currentUserId;

    // Create a map of taken positions
    final takenPositions = <int, Map<String, dynamic>>{};
    for (int i = 0; i < widget.order.length; i++) {
      final item = widget.order[i];
      final position = item['draftPosition'] as int?;
      if (position != null) {
        takenPositions[position] = item;
      }
    }

    final derbyStatus = widget.settings?.derbyStatus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Derby pick order
        DerbyPickOrderList(
          order: widget.order,
          currentPickerIndex: currentPickerIndex,
        ),

        // Current picker info
        DerbyStatusBanner(
          isMyTurn: isMyTurn,
          currentPickerName: currentPicker['username'] ?? 'player',
        ),

        // Commissioner pause/resume button
        if (widget.isCommissioner)
          DerbyControlButtons(
            derbyStatus: derbyStatus ?? '',
            showStartButton: false,
            onPause: () async {
              try {
                await ref
                    .read(draftOrderProvider((
                      leagueId: widget.leagueId,
                      draftId: widget.draftId
                    )).notifier)
                    .pauseDerby();
                // Only invalidate if widget is still mounted
                if (mounted) {
                  ref.invalidate(leagueDraftsProvider(widget.leagueId));
                }
              } catch (e) {
                // Error handling done in parent
                rethrow;
              }
            },
            onResume: () async {
              try {
                await ref
                    .read(draftOrderProvider((
                      leagueId: widget.leagueId,
                      draftId: widget.draftId
                    )).notifier)
                    .resumeDerby();
                // Only invalidate if widget is still mounted
                if (mounted) {
                  ref.invalidate(leagueDraftsProvider(widget.leagueId));
                }
              } catch (e) {
                // Error handling done in parent
                rethrow;
              }
            },
            onStart: () {
              // Not used in this context
            },
          ),

        // Slot selection grid
        DerbySlotGrid(
          draftOrder: widget.order,
          takenPositions: takenPositions,
          isMyTurn: isMyTurn,
          derbyStatus: derbyStatus ?? '',
          onSlotSelected: (slotNumber) async {
            try {
              await ref
                  .read(draftOrderProvider((
                    leagueId: widget.leagueId,
                    draftId: widget.draftId
                  )).notifier)
                  .pickSlot(slotNumber);
              // Only invalidate if widget is still mounted
              if (mounted) {
                ref.invalidate(leagueDraftsProvider(widget.leagueId));
              }
            } catch (e) {
              // Error handling done in parent
              rethrow;
            }
          },
        ),
      ],
    );
  }
}