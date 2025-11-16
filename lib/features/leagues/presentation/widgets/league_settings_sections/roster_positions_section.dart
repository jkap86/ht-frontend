import 'package:flutter/material.dart';

/// Dumb widget displaying roster positions
class RosterPositionsSection extends StatelessWidget {
  final Map<String, dynamic> rosterPositions;

  const RosterPositionsSection({
    super.key,
    required this.rosterPositions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: false,
        title: const Text(
          'Roster Positions',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: rosterPositions.entries
                  .where((e) => (e.value as num) > 0)
                  .map((e) => Chip(
                        label: Text('${e.key}: ${e.value}'),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
