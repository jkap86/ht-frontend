import 'package:flutter/material.dart';
import '../../../domain/league.dart';
import 'info_section.dart';
import 'info_row.dart';

/// Dumb widget displaying basic league information
class BasicInfoSection extends StatelessWidget {
  final League league;

  const BasicInfoSection({
    super.key,
    required this.league,
  });

  @override
  Widget build(BuildContext context) {
    return InfoSection(
      title: 'Basic Information',
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
          label: 'Status',
          value: _formatStatus(league.status),
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

  String _formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pre_draft':
        return 'Pre-Draft';
      case 'drafting':
        return 'Drafting';
      case 'in_season':
        return 'In Season';
      case 'complete':
        return 'Complete';
      default:
        return status;
    }
  }
}
