import 'package:flutter/material.dart';
import '../../domain/league.dart';
import '../../../../shared/widgets/cards/app_card.dart';
import '../../../../shared/widgets/chips/status_badge.dart';
import '../../../../shared/widgets/chips/info_chip.dart';

/// Displays the main league information in a card
/// Extracted component for better composition and reusability
class LeagueHeaderCard extends StatelessWidget {
  final League league;

  const LeagueHeaderCard({
    super.key,
    required this.league,
  });

  @override
  Widget build(BuildContext context) {
    final dues = (league.settings?['dues'] as num?)?.toDouble() ?? 0.0;

    return AppCard(
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          LeagueStatusBadge(status: league.status),
          InfoChip(
            icon: Icons.calendar_today,
            label: '${league.season} Season',
          ),
          InfoChip(
            icon: Icons.people,
            label: '${league.totalRosters} Teams',
          ),
          if (dues > 0)
            InfoChip(
              icon: Icons.attach_money,
              label: '\$${dues.toStringAsFixed(0)} Entry',
            ),
        ],
      ),
    );
  }
}

