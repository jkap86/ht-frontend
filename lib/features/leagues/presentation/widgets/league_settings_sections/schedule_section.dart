import 'package:flutter/material.dart';
import 'info_section.dart';
import 'info_row.dart';

/// Dumb widget displaying league schedule information
class ScheduleSection extends StatelessWidget {
  final Map<String, dynamic> settings;

  const ScheduleSection({
    super.key,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    final playoffsEnabled = settings['playoffs_enabled'] == true;

    return InfoSection(
      title: 'Schedule',
      children: [
        InfoRow(
          label: 'Start Week',
          value: '${settings['start_week'] ?? 'N/A'}',
        ),
        InfoRow(
          label: 'End Week',
          value: '${settings['end_week'] ?? 'N/A'}',
        ),
        InfoRow(
          label: 'Playoffs',
          value: playoffsEnabled ? 'Enabled' : 'Disabled',
        ),
        if (playoffsEnabled) ...[
          InfoRow(
            label: 'Playoff Start',
            value: 'Week ${settings['playoff_week_start']}',
          ),
          InfoRow(
            label: 'Playoff Teams',
            value: '${settings['playoff_teams']}',
          ),
        ],
      ],
    );
  }
}
