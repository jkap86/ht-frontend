import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/league.dart';
import '../../application/league_members_provider.dart';

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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dues',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            membersAsync.when(
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
                        _InfoColumn(
                          label: 'Managers',
                          value: '$totalMembers/${league.totalRosters}',
                        ),
                        // Paid
                        _InfoColumn(
                          label: 'Paid',
                          value: '$paidCount/${league.totalRosters}',
                        ),
                        // Buy In
                        _InfoColumn(
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
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: member.paid ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              member.paid ? 'Paid' : 'Unpaid',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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
          ],
        ),
      ),
    );
  }
}

/// Column displaying a label and value
class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;

  const _InfoColumn({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
