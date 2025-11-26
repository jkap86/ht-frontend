import 'package:flutter/material.dart';
import '../../../domain/league_creation_data.dart';

/// Dumb widget for basic league settings
/// Pure presentation - receives data and callbacks only
class BasicSettingsSection extends StatelessWidget {
  final LeagueCreationData data;
  final Function(String) onNameChanged;
  final Function(String) onSeasonChanged;
  final Function(int) onTotalRostersChanged;
  final Function(String) onSeasonTypeChanged;
  final Function(int) onStartWeekChanged;
  final Function(int) onEndWeekChanged;
  final Function(bool) onPlayoffsEnabledChanged;
  final Function(int) onPlayoffWeekStartChanged;
  final Function(int) onPlayoffTeamsChanged;
  final String? nameError;
  final String? seasonError;

  const BasicSettingsSection({
    super.key,
    required this.data,
    required this.onNameChanged,
    required this.onSeasonChanged,
    required this.onTotalRostersChanged,
    required this.onSeasonTypeChanged,
    required this.onStartWeekChanged,
    required this.onEndWeekChanged,
    required this.onPlayoffsEnabledChanged,
    required this.onPlayoffWeekStartChanged,
    required this.onPlayoffTeamsChanged,
    this.nameError,
    this.seasonError,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        title: const Text('Basic League Information'),
        leading: const Icon(Icons.info_outline),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  initialValue: data.name,
                  decoration: InputDecoration(
                    labelText: 'League Name',
                    hintText: 'Enter league name',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.sports_football),
                    errorText: nameError,
                  ),
                  onChanged: onNameChanged,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: data.season,
                  decoration: InputDecoration(
                    labelText: 'Season',
                    hintText: 'YYYY',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.calendar_today),
                    errorText: seasonError,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: onSeasonChanged,
                ),
                const SizedBox(height: 16),
                _NumberSelector(
                  label: 'Number of Teams',
                  value: data.totalRosters,
                  min: 2,
                  max: 20,
                  onChanged: onTotalRostersChanged,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: data.seasonType,
                  decoration: const InputDecoration(
                    labelText: 'Season Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'regular', child: Text('Regular Season')),
                    DropdownMenuItem(value: 'offseason', child: Text('Offseason')),
                  ],
                  onChanged: (value) {
                    if (value != null) onSeasonTypeChanged(value);
                  },
                ),
                const SizedBox(height: 16),
                _NumberSelector(
                  label: 'Start Week',
                  value: data.startWeek,
                  min: 1,
                  max: 18,
                  onChanged: onStartWeekChanged,
                ),
                const SizedBox(height: 16),
                _NumberSelector(
                  label: 'End Week',
                  value: data.endWeek,
                  min: data.startWeek,
                  max: 18,
                  onChanged: onEndWeekChanged,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Enable Playoffs'),
                  value: data.playoffsEnabled,
                  onChanged: onPlayoffsEnabledChanged,
                ),
                if (data.playoffsEnabled) ...[
                  const SizedBox(height: 16),
                  _NumberSelector(
                    label: 'Playoff Week Start',
                    value: data.playoffWeekStart,
                    min: data.startWeek + 1,
                    max: data.endWeek,
                    onChanged: onPlayoffWeekStartChanged,
                  ),
                  const SizedBox(height: 16),
                  _NumberSelector(
                    label: 'Playoff Teams',
                    value: data.playoffTeams,
                    min: 2,
                    max: 8,
                    onChanged: onPlayoffTeamsChanged,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable number selector widget
class _NumberSelector extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final Function(int) onChanged;

  const _NumberSelector({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: value > min ? () => onChanged(value - 1) : null,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value.toString(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: value < max ? () => onChanged(value + 1) : null,
        ),
      ],
    );
  }
}
