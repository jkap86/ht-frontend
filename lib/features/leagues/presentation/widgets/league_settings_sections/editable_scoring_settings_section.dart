import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Editable scoring settings section
class EditableScoringSettingsSection extends StatelessWidget {
  final Map<String, dynamic> scoringSettings;
  final Function(String, dynamic) onChanged;

  const EditableScoringSettingsSection({
    super.key,
    required this.scoringSettings,
    required this.onChanged,
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
                // Passing
                const Text(
                  'Passing',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildNumberField(
                        label: 'TD Points',
                        value: scoringSettings['passing_touchdowns'],
                        onChanged: (value) =>
                            onChanged('passing_touchdowns', value),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildNumberField(
                        label: 'Yards (pts/yd)',
                        value: scoringSettings['passing_yards'],
                        onChanged: (value) =>
                            onChanged('passing_yards', value),
                        isDecimal: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Rushing
                const Text(
                  'Rushing',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildNumberField(
                        label: 'TD Points',
                        value: scoringSettings['rushing_touchdowns'],
                        onChanged: (value) =>
                            onChanged('rushing_touchdowns', value),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildNumberField(
                        label: 'Yards (pts/yd)',
                        value: scoringSettings['rushing_yards'],
                        onChanged: (value) => onChanged('rushing_yards', value),
                        isDecimal: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Receiving
                const Text(
                  'Receiving',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildNumberField(
                        label: 'TD Points',
                        value: scoringSettings['receiving_touchdowns'],
                        onChanged: (value) =>
                            onChanged('receiving_touchdowns', value),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildNumberField(
                        label: 'Yards (pts/yd)',
                        value: scoringSettings['receiving_yards'],
                        onChanged: (value) =>
                            onChanged('receiving_yards', value),
                        isDecimal: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildNumberField(
                  label: 'Receptions (PPR)',
                  value: scoringSettings['receiving_receptions'],
                  onChanged: (value) =>
                      onChanged('receiving_receptions', value),
                  isDecimal: true,
                  helperText: '1.0 for full PPR, 0.5 for half PPR, 0 for standard',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberField({
    required String label,
    required dynamic value,
    required Function(num) onChanged,
    bool isDecimal = false,
    String? helperText,
  }) {
    return TextFormField(
      initialValue: value?.toString() ?? '0',
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        helperText: helperText,
        helperMaxLines: 2,
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: isDecimal),
      inputFormatters: [
        if (isDecimal)
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
        else
          FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (val) {
        if (isDecimal) {
          onChanged(double.tryParse(val) ?? 0.0);
        } else {
          onChanged(int.tryParse(val) ?? 0);
        }
      },
    );
  }
}
