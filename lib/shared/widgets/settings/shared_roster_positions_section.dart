import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/settings_mode.dart';

/// Unified roster positions section that works in view, edit, or create mode
class SharedRosterPositionsSection extends StatelessWidget {
  final SettingsMode mode;
  final Map<String, dynamic> rosterPositions;
  final Function(String, int)? onChanged;
  final bool? initiallyExpanded;
  final Function(bool)? onExpansionChanged;

  // Common fantasy positions
  static const positions = [
    'QB',
    'RB',
    'WR',
    'TE',
    'FLEX',
    'SUPER_FLEX',
    'K',
    'DEF',
    'BN',
    'IR',
  ];

  const SharedRosterPositionsSection({
    super.key,
    required this.mode,
    required this.rosterPositions,
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
          'Roster Positions',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (mode.isEditable) ...[
                  Text(
                    'Set the number of slots for each position',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...positions.map((position) => _buildPositionRow(context, position)),
                  const SizedBox(height: 8),
                  _buildInfoBox(context),
                ] else
                  _buildViewMode(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPositionRow(BuildContext context, String position) {
    final currentValue = (rosterPositions[position] as num?)?.toInt() ?? 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              _formatPositionName(position),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: currentValue > 0
                      ? () => onChanged?.call(position, currentValue - 1)
                      : null,
                ),
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    key: ValueKey('$position-$currentValue'),
                    initialValue: currentValue.toString(),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      final intValue = int.tryParse(value) ?? 0;
                      onChanged?.call(position, intValue);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => onChanged?.call(position, currentValue + 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewMode() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: rosterPositions.entries
          .where((e) => (e.value as num) > 0)
          .map((e) => Chip(
                label: Text('${e.key}: ${e.value}'),
              ))
          .toList(),
    );
  }

  Widget _buildInfoBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'FLEX = RB/WR/TE, SUPER_FLEX = QB/RB/WR/TE, BN = Bench, IR = Injured Reserve',
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatPositionName(String position) {
    switch (position) {
      case 'QB':
        return 'Quarterback';
      case 'RB':
        return 'Running Back';
      case 'WR':
        return 'Wide Receiver';
      case 'TE':
        return 'Tight End';
      case 'FLEX':
        return 'Flex';
      case 'SUPER_FLEX':
        return 'Super Flex';
      case 'K':
        return 'Kicker';
      case 'DEF':
        return 'Defense';
      case 'BN':
        return 'Bench';
      case 'IR':
        return 'Injured Reserve';
      default:
        return position;
    }
  }
}
