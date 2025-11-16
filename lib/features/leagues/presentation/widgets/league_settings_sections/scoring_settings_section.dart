import 'package:flutter/material.dart';
import 'info_row.dart';

/// Dumb widget displaying scoring settings
class ScoringSettingsSection extends StatelessWidget {
  final Map<String, dynamic> scoringSettings;

  const ScoringSettingsSection({
    super.key,
    required this.scoringSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: false,
        title: const Text(
          'Scoring Settings',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Passing',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                InfoRow(
                  label: 'Touchdowns',
                  value: '${scoringSettings['passing_touchdowns'] ?? 0} pts',
                ),
                InfoRow(
                  label: 'Yards',
                  value: '${scoringSettings['passing_yards'] ?? 0} pts/yd',
                ),
                const SizedBox(height: 12),
                const Text(
                  'Rushing',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                InfoRow(
                  label: 'Touchdowns',
                  value: '${scoringSettings['rushing_touchdowns'] ?? 0} pts',
                ),
                InfoRow(
                  label: 'Yards',
                  value: '${scoringSettings['rushing_yards'] ?? 0} pts/yd',
                ),
                const SizedBox(height: 12),
                const Text(
                  'Receiving',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                InfoRow(
                  label: 'Touchdowns',
                  value: '${scoringSettings['receiving_touchdowns'] ?? 0} pts',
                ),
                InfoRow(
                  label: 'Yards',
                  value: '${scoringSettings['receiving_yards'] ?? 0} pts/yd',
                ),
                InfoRow(
                  label: 'Receptions',
                  value: '${scoringSettings['receiving_receptions'] ?? 0} pts',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
