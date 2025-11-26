import 'package:flutter/material.dart';

/// Dumb widget for scoring settings
/// Pure presentation - receives data and callbacks only
class ScoringSettingsSection extends StatelessWidget {
  final Map<String, double> scoringSettings;
  final Function(Map<String, double>) onChanged;

  const ScoringSettingsSection({
    super.key,
    required this.scoringSettings,
    required this.onChanged,
  });

  void _updateScore(String key, String value) {
    final newValue = double.tryParse(value);
    if (newValue != null) {
      final updated = Map<String, double>.from(scoringSettings);
      updated[key] = newValue;
      onChanged(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: const Text('Scoring Settings'),
        leading: const Icon(Icons.calculate),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _ScoringField(
                  label: 'Passing Touchdowns',
                  value: scoringSettings['passing_touchdowns'] ?? 4.0,
                  onChanged: (value) => _updateScore('passing_touchdowns', value),
                ),
                const SizedBox(height: 12),
                _ScoringField(
                  label: 'Passing Yards (per yard)',
                  value: scoringSettings['passing_yards'] ?? 0.04,
                  onChanged: (value) => _updateScore('passing_yards', value),
                ),
                const SizedBox(height: 12),
                _ScoringField(
                  label: 'Rushing Touchdowns',
                  value: scoringSettings['rushing_touchdowns'] ?? 6.0,
                  onChanged: (value) => _updateScore('rushing_touchdowns', value),
                ),
                const SizedBox(height: 12),
                _ScoringField(
                  label: 'Rushing Yards (per yard)',
                  value: scoringSettings['rushing_yards'] ?? 0.1,
                  onChanged: (value) => _updateScore('rushing_yards', value),
                ),
                const SizedBox(height: 12),
                _ScoringField(
                  label: 'Receiving Touchdowns',
                  value: scoringSettings['receiving_touchdowns'] ?? 6.0,
                  onChanged: (value) => _updateScore('receiving_touchdowns', value),
                ),
                const SizedBox(height: 12),
                _ScoringField(
                  label: 'Receiving Yards (per yard)',
                  value: scoringSettings['receiving_yards'] ?? 0.1,
                  onChanged: (value) => _updateScore('receiving_yards', value),
                ),
                const SizedBox(height: 12),
                _ScoringField(
                  label: 'Receptions (PPR)',
                  value: scoringSettings['receiving_receptions'] ?? 1.0,
                  onChanged: (value) => _updateScore('receiving_receptions', value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoringField extends StatelessWidget {
  final String label;
  final double value;
  final Function(String) onChanged;

  const _ScoringField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value.toString(),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixText: 'pts',
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: onChanged,
    );
  }
}
