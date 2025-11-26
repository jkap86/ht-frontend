import 'package:flutter/material.dart';

/// Dumb widget for roster positions
/// Pure presentation - receives data and callbacks only
class RosterPositionsSection extends StatelessWidget {
  final Map<String, int> rosterPositions;
  final Function(Map<String, int>) onChanged;

  const RosterPositionsSection({
    super.key,
    required this.rosterPositions,
    required this.onChanged,
  });

  void _updatePosition(String key, int value) {
    final updated = Map<String, int>.from(rosterPositions);
    updated[key] = value;
    onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: const Text('Roster Positions'),
        leading: const Icon(Icons.people),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                for (var entry in rosterPositions.entries) ...[
                  _PositionSelector(
                    position: entry.key,
                    count: entry.value,
                    onChanged: (value) => _updatePosition(entry.key, value),
                  ),
                  if (entry.key != rosterPositions.keys.last)
                    const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PositionSelector extends StatelessWidget {
  final String position;
  final int count;
  final Function(int) onChanged;

  const _PositionSelector({
    required this.position,
    required this.count,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            position,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: count > 0 ? () => onChanged(count - 1) : null,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            count.toString(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: count < 10 ? () => onChanged(count + 1) : null,
        ),
      ],
    );
  }
}
