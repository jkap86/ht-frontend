import 'package:flutter/material.dart';

/// Basic draft settings section for create league flow
class CreateDraftBasicSettingsSection extends StatelessWidget {
  final String draftType;
  final bool thirdRoundReversal;
  final int draftRounds;
  final String playerPool;
  final Function(String) onDraftTypeChanged;
  final Function(bool) onThirdRoundReversalChanged;
  final Function(int) onDraftRoundsChanged;
  final Function(String) onPlayerPoolChanged;

  const CreateDraftBasicSettingsSection({
    super.key,
    required this.draftType,
    required this.thirdRoundReversal,
    required this.draftRounds,
    required this.playerPool,
    required this.onDraftTypeChanged,
    required this.onThirdRoundReversalChanged,
    required this.onDraftRoundsChanged,
    required this.onPlayerPoolChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Draft Type
        DropdownButtonFormField<String>(
          value: draftType,
          decoration: const InputDecoration(
            labelText: 'Draft Type',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'snake', child: Text('Snake Draft')),
            DropdownMenuItem(value: 'linear', child: Text('Linear Draft')),
          ],
          onChanged: (value) {
            if (value != null) onDraftTypeChanged(value);
          },
        ),
        const SizedBox(height: 16),

        // Third Round Reversal
        if (draftType == 'snake')
          SwitchListTile(
            title: const Text('Third Round Reversal'),
            subtitle: const Text('Reverses the draft order on the 3rd round',
                style: TextStyle(fontSize: 12)),
            value: thirdRoundReversal,
            onChanged: onThirdRoundReversalChanged,
          ),

        const SizedBox(height: 16),

        // Draft Rounds and Pick Time in a row
        TextFormField(
          key: ValueKey('draft_rounds_$draftRounds'),
          initialValue: draftRounds.toString(),
          decoration: const InputDecoration(
            labelText: 'Draft Rounds',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final rounds = int.tryParse(value);
            if (rounds != null) onDraftRoundsChanged(rounds);
          },
        ),
        const SizedBox(height: 16),

        // Player Pool
        DropdownButtonFormField<String>(
          value: playerPool,
          decoration: const InputDecoration(
              labelText: 'Player Pool', border: OutlineInputBorder()),
          items: const [
            DropdownMenuItem(value: 'all', child: Text('All Players')),
            DropdownMenuItem(value: 'rookie', child: Text('Rookie Only')),
            DropdownMenuItem(value: 'vet', child: Text('Veteran Only')),
          ],
          onChanged: (value) {
            if (value != null) onPlayerPoolChanged(value);
          },
        ),
      ],
    );
  }
}
