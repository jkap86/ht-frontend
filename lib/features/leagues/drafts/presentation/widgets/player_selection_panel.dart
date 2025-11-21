import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/draft_room_provider.dart';
import '../../domain/draft.dart';
import '../../domain/player.dart';

class PlayerSelectionPanel extends ConsumerStatefulWidget {
  final int leagueId;
  final int draftId;
  final Draft draft;

  const PlayerSelectionPanel({
    super.key,
    required this.leagueId,
    required this.draftId,
    required this.draft,
  });

  @override
  ConsumerState<PlayerSelectionPanel> createState() =>
      _PlayerSelectionPanelState();
}

class _PlayerSelectionPanelState extends ConsumerState<PlayerSelectionPanel> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _allPositions = ['QB', 'RB', 'WR', 'TE', 'K', 'DEF'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draftRoomState = ref.watch(
      draftRoomProvider((
        leagueId: widget.leagueId,
        draftId: widget.draftId,
        draft: widget.draft,
      )),
    );

    final notifier = ref.read(
      draftRoomProvider((
        leagueId: widget.leagueId,
        draftId: widget.draftId,
        draft: widget.draft,
      )).notifier,
    );

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search players...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        notifier.updateSearchQuery('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              notifier.updateSearchQuery(value);
            },
          ),
        ),

        // Position filters
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Wrap(
            spacing: 8.0,
            children: _allPositions.map((position) {
              final isSelected =
                  draftRoomState.positionFilters.contains(position);
              return FilterChip(
                label: Text(position),
                selected: isSelected,
                onSelected: (selected) {
                  notifier.togglePositionFilter(position);
                },
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 8),

        // Players list
        Expanded(
          child: draftRoomState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : draftRoomState.error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, size: 48, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${draftRoomState.error}',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : draftRoomState.filteredPlayers.isEmpty
                      ? const Center(
                          child: Text('No players available'),
                        )
                      : ListView.builder(
                          itemCount: draftRoomState.filteredPlayers.length,
                          itemBuilder: (context, index) {
                            final player =
                                draftRoomState.filteredPlayers[index];
                            return PlayerCard(
                              player: player,
                              canPick: draftRoomState.canMakePick,
                              onPick: () async {
                                try {
                                  await notifier.makePick(player.id);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Picked ${player.fullName}!',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Failed to make pick: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                            );
                          },
                        ),
        ),
      ],
    );
  }
}

class PlayerCard extends StatelessWidget {
  final Player player;
  final bool canPick;
  final VoidCallback onPick;

  const PlayerCard({
    super.key,
    required this.player,
    required this.canPick,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getPositionColor(player.displayPosition),
          child: Text(
            player.displayPosition,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          player.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            Text('${player.displayTeam} • '),
            Text('${player.age ?? 0}yo • '),
            Text('${player.yearsExp ?? 0} yrs exp'),
            if (player.isRookie) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'ROOKIE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        trailing: canPick
            ? ElevatedButton(
                onPressed: onPick,
                child: const Text('Pick'),
              )
            : const Icon(Icons.lock, color: Colors.grey),
      ),
    );
  }

  Color _getPositionColor(String position) {
    switch (position) {
      case 'QB':
        return Colors.red;
      case 'RB':
        return Colors.blue;
      case 'WR':
        return Colors.green;
      case 'TE':
        return Colors.orange;
      case 'K':
        return Colors.purple;
      case 'DEF':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }
}
