import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/league.dart';
import '../../application/league_members_provider.dart';
import '../../../../../shared/widgets/cards/section_card.dart';
import '../../../../../shared/widgets/chips/status_badge.dart';
import '../../../../../shared/widgets/chips/info_row.dart';

/// Card showing dues overview with managers, paid status, and buy-in
class DuesOverviewCard extends ConsumerWidget {
  final League league;

  const DuesOverviewCard({
    super.key,
    required this.league,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(leagueMembersProvider(league.id));
    final dues = (league.settings?['dues'] as num?)?.toDouble() ?? 0.0;

    return SectionCard(
      title: 'Dues',
      child: membersAsync.when(
              data: (members) {
                final paidCount = members.where((m) => m.paid).length;
                final totalMembers = members.length;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row with stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Managers
                        InfoColumn(
                          label: 'Managers',
                          value: '$totalMembers/${league.totalRosters}',
                        ),
                        // Paid
                        InfoColumn(
                          label: 'Paid',
                          value: '$paidCount/${league.totalRosters}',
                        ),
                        // Buy In
                        InfoColumn(
                          label: 'Buy In',
                          value: dues > 0 ? '\$${dues.toStringAsFixed(0)}' : 'Free',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    // Members list
                    ...members.map((member) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            member.username,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          PaymentStatusBadge(isPaid: member.paid),
                        ],
                      ),
                    )),
                  ],
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
                  'Error loading dues info: $error',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ),
    );
  }
}
