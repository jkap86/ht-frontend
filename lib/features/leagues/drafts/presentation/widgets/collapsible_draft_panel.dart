import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/draft.dart';
import 'player_selection_panel.dart';
import 'draft_queue_widget.dart';
import '../../../../../shared/widgets/collapsible/collapsible_widget.dart';

/// Collapsible draft panel that shows player selection and activity feed
class CollapsibleDraftPanel extends CollapsibleWidget {
  final int leagueId;
  final int draftId;
  final Draft draft;

  const CollapsibleDraftPanel({
    super.key,
    required this.leagueId,
    required this.draftId,
    required this.draft,
  }) : super(
          stateKey: 'draft_panel_$draftId',
          position: CollapsiblePosition.bottomLeft,
          defaultExpandedSize: const Size(500, 800),
        );

  @override
  ConsumerState<CollapsibleDraftPanel> createState() =>
      _CollapsibleDraftPanelState();
}

class _CollapsibleDraftPanelState
    extends CollapsibleWidgetState<CollapsibleDraftPanel> {
  int _selectedTab = 0;

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
            Icons.people_outline,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }

  @override
  Widget buildExpandedContent(BuildContext context) {
    return Column(
      children: [
        // Tab bar
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _TabButton(
                  label: 'Players',
                  icon: Icons.sports,
                  isSelected: _selectedTab == 0,
                  onTap: () => setState(() => _selectedTab = 0),
                ),
              ),
              Expanded(
                child: _TabButton(
                  label: 'Queue',
                  icon: Icons.queue_outlined,
                  isSelected: _selectedTab == 1,
                  onTap: () => setState(() => _selectedTab = 1),
                ),
              ),
              Expanded(
                child: _TabButton(
                  label: 'Activity',
                  icon: Icons.history,
                  isSelected: _selectedTab == 2,
                  onTap: () => setState(() => _selectedTab = 2),
                ),
              ),
            ],
          ),
        ),
        // Content
        Expanded(
          child: IndexedStack(
            index: _selectedTab,
            children: [
              PlayerSelectionPanel(
                leagueId: widget.leagueId,
                draftId: widget.draftId,
                draft: widget.draft,
              ),
              DraftQueueWidget(
                leagueId: widget.leagueId,
                draftId: widget.draftId,
              ),
              _ActivityFeedPanel(
                leagueId: widget.leagueId,
                draftId: widget.draftId,
                draft: widget.draft,
              ),
            ],
          ),
        ),
      ],
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
          const Icon(Icons.people_outline, size: 18),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Draft Panel',
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

class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityFeedPanel extends ConsumerWidget {
  final int leagueId;
  final int draftId;
  final Draft draft;

  const _ActivityFeedPanel({
    required this.leagueId,
    required this.draftId,
    required this.draft,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: const Center(
        child: Text('Activity Feed Panel'),
      ),
    );
  }
}
