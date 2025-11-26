import 'package:flutter/material.dart';
import '../../../domain/league.dart';
import 'info_section.dart';
import 'info_row.dart';

/// Dumb widget displaying basic league information
class BasicInfoSection extends StatelessWidget {
  final League league;
  final bool? initiallyExpanded;
  final Function(bool)? onExpansionChanged;

  const BasicInfoSection({
    super.key,
    required this.league,
    this.initiallyExpanded,
    this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InfoSection(
      title: 'Basic Information',
      initiallyExpanded: initiallyExpanded,
      onExpansionChanged: onExpansionChanged,
      children: [
        InfoRow(
          label: 'Season',
          value: league.season,
        ),
        InfoRow(
          label: 'Season Type',
          value: _formatSeasonType(league.seasonType),
        ),
        InfoRow(
          label: 'Total Teams',
          value: '${league.totalRosters}',
        ),
        InfoRow(
          label: 'League Type',
          value: league.settings?['is_public'] == true ? 'Public' : 'Private',
        ),
      ],
    );
  }

  String _formatSeasonType(String seasonType) {
    switch (seasonType.toLowerCase()) {
      case 'regular':
        return 'Regular Season';
      case 'playoff':
        return 'Playoff';
      case 'dynasty':
        return 'Dynasty';
      default:
        return seasonType;
    }
  }
}
