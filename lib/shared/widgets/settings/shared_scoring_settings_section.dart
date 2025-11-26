import 'package:flutter/material.dart';
import '../../models/settings_mode.dart';
import '../forms/form_field_builder.dart' as fields;

/// Unified scoring settings section that works in view, edit, or create mode
class SharedScoringSettingsSection extends StatelessWidget {
  final SettingsMode mode;
  final Map<String, dynamic> scoringSettings;
  final Function(String, dynamic)? onChanged;
  final bool? initiallyExpanded;
  final Function(bool)? onExpansionChanged;

  const SharedScoringSettingsSection({
    super.key,
    required this.mode,
    required this.scoringSettings,
    this.onChanged,
    this.initiallyExpanded,
    this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded ?? mode.isEditable,
        onExpansionChanged: onExpansionChanged,
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
                _buildPassingSection(),
                fields.SettingsFormFields.buildDivider(),
                _buildRushingSection(),
                fields.SettingsFormFields.buildDivider(),
                _buildReceivingSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        fields.SettingsFormFields.buildSectionHeader('Passing'),
        if (mode.isEditable)
          Row(
            children: [
              Expanded(
                child: fields.SettingsFormFields.buildNumberField(
                  label: 'TD Points',
                  value: scoringSettings['passing_touchdowns'],
                  mode: mode,
                  onChanged: (value) => onChanged?.call('passing_touchdowns', value),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: fields.SettingsFormFields.buildNumberField(
                  label: 'Yards',
                  value: scoringSettings['passing_yards'],
                  mode: mode,
                  isDecimal: true,
                  suffix: 'pts/yd',
                  onChanged: (value) => onChanged?.call('passing_yards', value),
                ),
              ),
            ],
          )
        else ...[
          fields.SettingsFormFields.buildNumberField(
            label: 'Touchdowns',
            value: scoringSettings['passing_touchdowns'],
            mode: mode,
            suffix: 'pts',
          ),
          fields.SettingsFormFields.buildNumberField(
            label: 'Yards',
            value: scoringSettings['passing_yards'],
            mode: mode,
            suffix: 'pts/yd',
          ),
        ],
      ],
    );
  }

  Widget _buildRushingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        fields.SettingsFormFields.buildSectionHeader('Rushing'),
        if (mode.isEditable)
          Row(
            children: [
              Expanded(
                child: fields.SettingsFormFields.buildNumberField(
                  label: 'TD Points',
                  value: scoringSettings['rushing_touchdowns'],
                  mode: mode,
                  onChanged: (value) => onChanged?.call('rushing_touchdowns', value),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: fields.SettingsFormFields.buildNumberField(
                  label: 'Yards',
                  value: scoringSettings['rushing_yards'],
                  mode: mode,
                  isDecimal: true,
                  suffix: 'pts/yd',
                  onChanged: (value) => onChanged?.call('rushing_yards', value),
                ),
              ),
            ],
          )
        else ...[
          fields.SettingsFormFields.buildNumberField(
            label: 'Touchdowns',
            value: scoringSettings['rushing_touchdowns'],
            mode: mode,
            suffix: 'pts',
          ),
          fields.SettingsFormFields.buildNumberField(
            label: 'Yards',
            value: scoringSettings['rushing_yards'],
            mode: mode,
            suffix: 'pts/yd',
          ),
        ],
      ],
    );
  }

  Widget _buildReceivingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        fields.SettingsFormFields.buildSectionHeader('Receiving'),
        if (mode.isEditable)
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: fields.SettingsFormFields.buildNumberField(
                      label: 'TD Points',
                      value: scoringSettings['receiving_touchdowns'],
                      mode: mode,
                      onChanged: (value) => onChanged?.call('receiving_touchdowns', value),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: fields.SettingsFormFields.buildNumberField(
                      label: 'Yards',
                      value: scoringSettings['receiving_yards'],
                      mode: mode,
                      isDecimal: true,
                      suffix: 'pts/yd',
                      onChanged: (value) => onChanged?.call('receiving_yards', value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              fields.SettingsFormFields.buildNumberField(
                label: 'Receptions',
                value: scoringSettings['receiving_receptions'],
                mode: mode,
                suffix: 'pts',
                onChanged: (value) => onChanged?.call('receiving_receptions', value),
              ),
            ],
          )
        else ...[
          fields.SettingsFormFields.buildNumberField(
            label: 'Touchdowns',
            value: scoringSettings['receiving_touchdowns'],
            mode: mode,
            suffix: 'pts',
          ),
          fields.SettingsFormFields.buildNumberField(
            label: 'Yards',
            value: scoringSettings['receiving_yards'],
            mode: mode,
            suffix: 'pts/yd',
          ),
          fields.SettingsFormFields.buildNumberField(
            label: 'Receptions',
            value: scoringSettings['receiving_receptions'],
            mode: mode,
            suffix: 'pts',
          ),
        ],
      ],
    );
  }
}
