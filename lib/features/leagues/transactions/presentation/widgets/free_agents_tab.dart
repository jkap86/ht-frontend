import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/waiver_provider.dart';
import '../../domain/waiver_claim.dart';
import 'add_player_dialog.dart';

class FreeAgentsTab extends ConsumerStatefulWidget {
  final int leagueId;
  final int? userRosterId;

  const FreeAgentsTab({
    super.key,
    required this.leagueId,
    this.userRosterId,
  });

  @override
  ConsumerState<FreeAgentsTab> createState() => _FreeAgentsTabState();
}

class _FreeAgentsTabState extends ConsumerState<FreeAgentsTab> {
  String _searchQuery = '';
  String? _positionFilter;
  final TextEditingController _searchController = TextEditingController();

  static const _positions = ['All', 'QB', 'RB', 'WR', 'TE', 'K', 'DEF'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playersAsync = ref.watch(freeAgentsNotifierProvider(widget.leagueId));

    return Column(
      children: [
        // Search and filter bar
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Search field
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search players...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
              const SizedBox(height: 8),
              // Position filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _positions.map((pos) {
                    final isSelected = (_positionFilter == null && pos == 'All') ||
                        _positionFilter == pos;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: FilterChip(
                        label: Text(pos, style: const TextStyle(fontSize: 11)),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _positionFilter = pos == 'All' ? null : pos;
                          });
                        },
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        // Players list
        Expanded(
          child: playersAsync.when(
            data: (players) {
              // Apply filters
              var filteredPlayers = players.where((p) {
                if (_searchQuery.isNotEmpty) {
                  if (!p.playerName.toLowerCase().contains(_searchQuery.toLowerCase())) {
                    return false;
                  }
                }
                if (_positionFilter != null && p.position != _positionFilter) {
                  return false;
                }
                return true;
              }).toList();

              // Sort: free agents first, then by name
              filteredPlayers.sort((a, b) {
                if (a.isOnWaivers && !b.isOnWaivers) return 1;
                if (!a.isOnWaivers && b.isOnWaivers) return -1;
                return a.playerName.compareTo(b.playerName);
              });

              if (filteredPlayers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_search,
                        size: 48,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _searchQuery.isNotEmpty || _positionFilter != null
                            ? 'No players match your filters'
                            : 'No available players',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => ref.read(freeAgentsNotifierProvider(widget.leagueId).notifier).refresh(),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: filteredPlayers.length,
                  itemBuilder: (context, index) {
                    final player = filteredPlayers[index];
                    return _buildPlayerTile(context, player);
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text('Error: $error'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(freeAgentsNotifierProvider(widget.leagueId)),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerTile(BuildContext context, AvailablePlayer player) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getPositionColor(player.position),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              player.position,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        title: Text(
          player.playerName,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Row(
          children: [
            Text(
              player.team,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            if (player.isOnWaivers) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Waivers',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        trailing: widget.userRosterId != null
            ? IconButton(
                icon: Icon(
                  player.isOnWaivers ? Icons.gavel : Icons.add_circle_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () => _showAddPlayerDialog(context, player),
                tooltip: player.isOnWaivers ? 'Submit claim' : 'Add player',
              )
            : null,
        dense: true,
      ),
    );
  }

  void _showAddPlayerDialog(BuildContext context, AvailablePlayer player) {
    showDialog(
      context: context,
      builder: (context) => AddPlayerDialog(
        leagueId: widget.leagueId,
        player: player,
        userRosterId: widget.userRosterId!,
      ),
    );
  }

  Color _getPositionColor(String position) {
    switch (position.toUpperCase()) {
      case 'QB':
        return Colors.red;
      case 'RB':
        return Colors.green;
      case 'WR':
        return Colors.blue;
      case 'TE':
        return Colors.orange;
      case 'K':
        return Colors.teal;
      case 'DEF':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }
}
