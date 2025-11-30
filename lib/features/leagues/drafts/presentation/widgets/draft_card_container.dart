import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/league.dart';
import '../../domain/draft.dart';
import '../../application/drafts_provider.dart';
import '../../../../../core/services/socket/socket_providers.dart';
import '../../../../../shared/widgets/cards/expandable_card.dart';
import 'draft_header_bar.dart';
import 'draft_order_content_widget.dart';

/// Individual draft card with collapsible sections
class DraftCardContainer extends ConsumerStatefulWidget {
  final Draft draft;
  final int draftNumber;
  final int leagueId;
  final bool isCommissioner;
  final League league;

  const DraftCardContainer({
    super.key,
    required this.draft,
    required this.draftNumber,
    required this.leagueId,
    required this.isCommissioner,
    required this.league,
  });

  @override
  ConsumerState<DraftCardContainer> createState() => _DraftCardContainerState();
}

class _DraftCardContainerState extends ConsumerState<DraftCardContainer> {
  bool _isExpanded = false;
  String? _expandedSection; // Track which section is expanded
  void Function()? _derbyUpdateListener;
  String? _joinedRoomName;

  @override
  void initState() {
    super.initState();
    _setupDerbyUpdateListener();
  }

  @override
  void dispose() {
    _derbyUpdateListener?.call();
    // Leave the room when disposing
    if (_joinedRoomName != null) {
      final socketService = ref.read(socketServiceProvider);
      socketService.leaveRoom(_joinedRoomName!);
    }
    super.dispose();
  }

  void _setupDerbyUpdateListener() {
    // Get the socket service and listen for derby updates
    final socketService = ref.read(socketServiceProvider);

    // Join the league room to receive derby update events
    final roomName = 'league_${widget.leagueId}';
    socketService.joinRoom(roomName);
    _joinedRoomName = roomName;

    _derbyUpdateListener = socketService.on('derby_updated', (data) {
      if (data is Map<String, dynamic>) {
        final draftId = data['draft_id'];

        // Only refresh if this event is for our draft
        if (draftId == widget.draft.id) {
          print('[DraftCardContainer] Derby updated for draft ${widget.draft.id}, refreshing...');

          // Refresh the draft order provider
          ref.invalidate(draftOrderProvider((leagueId: widget.leagueId, draftId: widget.draft.id)));

          // Also refresh the drafts list to get updated settings
          ref.invalidate(leagueDraftsProvider(widget.leagueId));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      elevation: 2,
      initiallyExpanded: _isExpanded,
      onToggle: (expanded) => setState(() => _isExpanded = expanded),
      headerPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      showDivider: true,
      header: DraftHeaderBar(
        draftName: 'Draft ${widget.draftNumber}',
        draftTypeLabel: _formatDraftType(widget.draft.draftType),
        rounds: widget.draft.rounds,
        playerPoolLabel: _formatPlayerPool(widget.draft.settings?.playerPool ?? 'all'),
      ),
      child: _buildDraftOrderSection(),
    );
  }

  Widget _buildDraftOrderSection() {
    final isExpanded = _expandedSection == 'draft_order';
    final settings = widget.draft.settings;
    final draftOrder = settings?.draftOrder ?? 'random';
    final draftOrderLabel =
        draftOrder.toLowerCase() == 'derby' ? 'Derby' : 'Randomize';

    return ExpandableSection(
      title: 'Draft Order',
      badge: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          draftOrderLabel,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ),
      isExpanded: isExpanded,
      onToggle: () => setState(() {
        _expandedSection = isExpanded ? null : 'draft_order';
      }),
      child: DraftOrderContentWidget(
        draft: widget.draft,
        leagueId: widget.leagueId,
        isCommissioner: widget.isCommissioner,
        league: widget.league,
      ),
    );
  }

  String _formatDraftType(String draftType) {
    switch (draftType.toLowerCase()) {
      case 'snake':
        return 'Snake';
      case 'linear':
        return 'Linear';
      case 'auction':
        return 'Auction';
      default:
        return draftType;
    }
  }

  String _formatPlayerPool(String playerPool) {
    switch (playerPool.toLowerCase()) {
      case 'all':
        return 'All Players';
      case 'nfl':
        return 'NFL Only';
      case 'rookies':
        return 'Rookies Only';
      default:
        return playerPool;
    }
  }
}
