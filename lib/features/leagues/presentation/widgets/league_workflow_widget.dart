import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/league.dart';
import '../../dues_payouts/application/league_members_provider.dart';
import '../../drafts/application/drafts_provider.dart';

/// Horizontal workflow showing league stages
class LeagueWorkflowWidget extends ConsumerStatefulWidget {
  final League league;
  final Function(String) onStepSelected;

  const LeagueWorkflowWidget({
    super.key,
    required this.league,
    required this.onStepSelected,
  });

  @override
  ConsumerState<LeagueWorkflowWidget> createState() => _LeagueWorkflowWidgetState();
}

class _LeagueWorkflowWidgetState extends ConsumerState<LeagueWorkflowWidget> {
  String? _selectedStep;

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(leagueMembersProvider(widget.league.id));
    final draftsAsync = ref.watch(leagueDraftsProvider(widget.league.id));

    // Determine default step if none selected
    String defaultStep = 'Dues';
    membersAsync.whenData((members) {
      if (members.isNotEmpty) {
        final allPaid = members.every((m) => m.paid);
        final leagueFull = members.length >= widget.league.totalRosters;

        // If league is full and all paid, default to Draft
        if (leagueFull && allPaid) {
          defaultStep = 'Draft';
        }
      }
    });

    // Check if all drafts are completed, if so, default to Matchups
    draftsAsync.whenData((drafts) {
      if (drafts.isNotEmpty) {
        final allDraftsCompleted = drafts.every((draft) => draft.status == 'completed');
        if (allDraftsCompleted) {
          defaultStep = 'Matchups';
        }
      }
    });

    // Use selected step if set, otherwise use default
    final selectedStep = _selectedStep ?? defaultStep;

    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _WorkflowStep(
            icon: Icons.attach_money,
            title: 'Dues',
            isSelected: selectedStep == 'Dues',
            onTap: () => _handleStepTap('Dues'),
          ),
          _WorkflowStep(
            icon: Icons.dynamic_feed,
            title: 'Draft',
            isSelected: selectedStep == 'Draft',
            onTap: () => _handleStepTap('Draft'),
          ),
          _WorkflowStep(
            icon: Icons.sports_football,
            title: 'Matchups',
            isSelected: selectedStep == 'Matchups',
            onTap: () => _handleStepTap('Matchups'),
          ),
          _WorkflowStep(
            icon: Icons.leaderboard,
            title: 'Standings',
            isSelected: selectedStep == 'Standings',
            onTap: () => _handleStepTap('Standings'),
          ),
          _WorkflowStep(
            icon: Icons.emoji_events,
            title: 'Playoffs',
            isSelected: selectedStep == 'Playoffs',
            onTap: () => _handleStepTap('Playoffs'),
          ),
          _WorkflowStep(
            icon: Icons.payments,
            title: 'Payouts',
            isSelected: selectedStep == 'Payouts',
            onTap: () => _handleStepTap('Payouts'),
          ),
        ],
      ),
    );
  }

  void _handleStepTap(String step) {
    setState(() {
      _selectedStep = step;
    });
    widget.onStepSelected(step);
  }
}

/// Individual workflow step card
class _WorkflowStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _WorkflowStep({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 8),
      child: Card(
        color: isSelected
            ? Theme.of(context).colorScheme.primaryContainer
            : null,
        elevation: isSelected ? 4 : 1,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : null,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
