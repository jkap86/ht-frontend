import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/league.dart';
import '../../application/drafts_provider.dart';
import 'draft_card_container.dart';
import '../../../../../shared/widgets/cards/section_card.dart';

/// Card showing draft overview with draft details
class DraftOverviewCard extends ConsumerWidget {
  final League league;

  const DraftOverviewCard({
    super.key,
    required this.league,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftsAsync = ref.watch(leagueDraftsProvider(league.id));

    return SectionCard(
      title: 'Draft',
      child: draftsAsync.when(
              data: (drafts) {
                if (drafts.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        'No drafts configured',
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  );
                }

                // Show all drafts as collapsible cards
                return Column(
                  children: drafts.asMap().entries.map((entry) {
                    final index = entry.key;
                    final draft = entry.value;

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < drafts.length - 1 ? 16 : 0,
                      ),
                      child: DraftCardContainer(
                        draft: draft,
                        draftNumber: index + 1,
                        leagueId: league.id,
                        isCommissioner: league.isCommissioner,
                        league: league,
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Error loading draft info: $error',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
      ),
    );
  }
}
