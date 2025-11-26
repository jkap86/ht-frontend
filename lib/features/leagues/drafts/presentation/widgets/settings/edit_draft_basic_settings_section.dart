import 'package:flutter/material.dart';

/// Basic draft settings section (type, rounds, player pool)
class EditDraftBasicSettingsSection extends StatelessWidget {
  final String draftType;
  final bool thirdRoundReversal;
  final int draftRounds;
  final String playerPool;
  final bool useRosterPositions;
  final bool isCommissioner;
  final Function(String) onDraftTypeChanged;
  final Function(bool) onThirdRoundReversalChanged;
  final Function(int) onDraftRoundsChanged;
  final Function(String) onPlayerPoolChanged;

  const EditDraftBasicSettingsSection({
    super.key,
    required this.draftType,
    required this.thirdRoundReversal,
    required this.draftRounds,
    required this.playerPool,
    required this.useRosterPositions,
    required this.isCommissioner,
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
          onChanged: isCommissioner
              ? (value) {
                  if (value != null) onDraftTypeChanged(value);
                }
              : null,
        ),
        const SizedBox(height: 16),

        // Third Round Reversal
        if (draftType == 'snake')
          SwitchListTile(
            title: const Text('Third Round Reversal'),
            subtitle: const Text('Reverses the draft order on the 3rd round',
                style: TextStyle(fontSize: 12)),
            value: thirdRoundReversal,
            onChanged: isCommissioner ? onThirdRoundReversalChanged : null,
          ),

        const SizedBox(height: 16),

        // Draft Rounds
        TextFormField(
          key: ValueKey('draft_rounds_$useRosterPositions'),
          initialValue: draftRounds.toString(),
          decoration: const InputDecoration(
            labelText: 'Draft Rounds',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          enabled: isCommissioner && !useRosterPositions,
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
          onChanged: isCommissioner
              ? (value) {
                  if (value != null) onPlayerPoolChanged(value);
                }
              : null,
        ),
      ],
    );
  }
}
