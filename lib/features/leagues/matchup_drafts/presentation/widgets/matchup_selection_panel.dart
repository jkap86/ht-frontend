import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../drafts/domain/draft.dart';
import '../../application/matchup_drafts_provider.dart';
import '../../../../../shared/widgets/collapsible/collapsible_widget.dart';
import 'matchup_list_view.dart';

/// Collapsible matchup selection panel
class MatchupSelectionPanel extends CollapsibleWidget {
  final int leagueId;
  final int draftId;
  final Draft draft;

  const MatchupSelectionPanel({
    super.key,
    required this.leagueId,
    required this.draftId,
    required this.draft,
  }) : super(
          stateKey: 'matchup_draft_panel_$draftId',
          position: CollapsiblePosition.bottomLeft,
          defaultExpandedSize: const Size(500, 800),
        );

  @override
  ConsumerState<MatchupSelectionPanel> createState() =>
      _MatchupSelectionPanelState();
}

class _MatchupSelectionPanelState
    extends CollapsibleWidgetState<MatchupSelectionPanel> {
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
            Icons.calendar_month_outlined,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }

  @override
  Widget buildExpandedContent(BuildContext context) {
    return const _MatchupSelectionContent();
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
          const Icon(Icons.calendar_month_outlined, size: 18),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Select Matchup',
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

class _MatchupSelectionContent extends ConsumerStatefulWidget {
  const _MatchupSelectionContent();

  @override
  ConsumerState<_MatchupSelectionContent> createState() =>
      _MatchupSelectionContentState();
}

class _MatchupSelectionContentState
    extends ConsumerState<_MatchupSelectionContent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get draft state from ancestor context
    final matchupSelectionPanel =
        context.findAncestorWidgetOfExactType<MatchupSelectionPanel>();
    if (matchupSelectionPanel == null) {
      return const Center(child: Text('Error: Panel context not found'));
    }

    final draftRoomState = ref.watch(
      matchupDraftRoomProvider((
        leagueId: matchupSelectionPanel.leagueId,
        draftId: matchupSelectionPanel.draftId,
        draft: matchupSelectionPanel.draft,
      )),
    );

    final notifier = ref.read(
      matchupDraftRoomProvider((
        leagueId: matchupSelectionPanel.leagueId,
        draftId: matchupSelectionPanel.draftId,
        draft: matchupSelectionPanel.draft,
      )).notifier,
    );

    // Get unique weeks from available matchups
    final availableWeeks = draftRoomState.availableMatchups
        .map((m) => m.weekNumber)
        .toSet()
        .toList()
      ..sort();

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search rosters...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        notifier.updateSearchQuery('');
                      },
                    )
                  : null,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: (value) {
              notifier.updateSearchQuery(value);
            },
          ),
        ),

        // Week filter chips
        if (availableWeeks.isNotEmpty)
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              children: [
                ...availableWeeks.map((week) {
                  final isSelected = draftRoomState.weekFilters.contains(week);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text('Week $week'),
                      selected: isSelected,
                      onSelected: (selected) {
                        notifier.toggleWeekFilter(week);
                      },
                    ),
                  );
                }),
                if (draftRoomState.weekFilters.isNotEmpty)
                  TextButton.icon(
                    onPressed: () {
                      notifier.clearWeekFilters();
                    },
                    icon: const Icon(Icons.clear, size: 16),
                    label: const Text('Clear'),
                  ),
              ],
            ),
          ),

        const Divider(height: 1),

        // Matchup list
        Expanded(
          child: MatchupListView(
            matchups: draftRoomState.filteredMatchups,
            canMakePick: draftRoomState.canMakePick,
            onMakeMatchupPick: notifier.makeMatchupPick,
          ),
        ),
      ],
    );
  }
}
