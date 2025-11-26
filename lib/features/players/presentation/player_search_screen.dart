import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/player.dart';
import '../application/player_search_provider.dart';
import 'player_detail_screen.dart';

class PlayerSearchScreen extends ConsumerStatefulWidget {
  const PlayerSearchScreen({super.key});

  @override
  ConsumerState<PlayerSearchScreen> createState() => _PlayerSearchScreenState();
}

class _PlayerSearchScreenState extends ConsumerState<PlayerSearchScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load active players on initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(playerSearchProvider.notifier).loadActivePlayers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(playerSearchProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Players'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              _searchController.clear();
              ref.read(playerSearchProvider.notifier).clearFilters();
            },
            tooltip: 'Clear filters',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilters(),
          const Divider(height: 1),
          Expanded(
            child: _buildPlayersList(searchState),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search players by name...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(playerSearchProvider.notifier).updateSearchQuery('');
                    ref.read(playerSearchProvider.notifier).searchPlayers();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: (value) {
          ref.read(playerSearchProvider.notifier).updateSearchQuery(value);
        },
        onSubmitted: (_) {
          ref.read(playerSearchProvider.notifier).searchPlayers();
        },
      ),
    );
  }

  Widget _buildFilters() {
    final searchState = ref.watch(playerSearchProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          const Text('Filters:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(
            child: Wrap(
              spacing: 8,
              children: [
                _buildPositionFilter(searchState.selectedPosition),
                _buildTeamFilter(searchState.selectedTeam),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPositionFilter(String? selectedPosition) {
    final positions = ['QB', 'RB', 'WR', 'TE', 'K', 'DEF'];

    return DropdownButton<String>(
      value: selectedPosition,
      hint: const Text('Position'),
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('All Positions'),
        ),
        ...positions.map((pos) => DropdownMenuItem(
              value: pos,
              child: Text(pos),
            )),
      ],
      onChanged: (value) {
        ref.read(playerSearchProvider.notifier).updatePositionFilter(value);
      },
    );
  }

  Widget _buildTeamFilter(String? selectedTeam) {
    // Common NFL teams (simplified list)
    final teams = [
      'ARI', 'ATL', 'BAL', 'BUF', 'CAR', 'CHI', 'CIN', 'CLE',
      'DAL', 'DEN', 'DET', 'GB', 'HOU', 'IND', 'JAX', 'KC',
      'LAC', 'LAR', 'LV', 'MIA', 'MIN', 'NE', 'NO', 'NYG',
      'NYJ', 'PHI', 'PIT', 'SEA', 'SF', 'TB', 'TEN', 'WAS',
    ];

    return DropdownButton<String>(
      value: selectedTeam,
      hint: const Text('Team'),
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('All Teams'),
        ),
        ...teams.map((team) => DropdownMenuItem(
              value: team,
              child: Text(team),
            )),
      ],
      onChanged: (value) {
        ref.read(playerSearchProvider.notifier).updateTeamFilter(value);
      },
    );
  }

  Widget _buildPlayersList(PlayerSearchState searchState) {
    if (searchState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (searchState.error != null) {
      return _buildError(searchState.error!);
    }

    if (searchState.players.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No players found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: searchState.players.length,
      itemBuilder: (context, index) {
        final player = searchState.players[index];
        return _buildPlayerCard(player);
      },
    );
  }

  Widget _buildPlayerCard(Player player) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            player.displayPosition.substring(0, 2),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          player.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${player.displayPosition} - ${player.displayTeam}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (player.isRookie)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'R',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayerDetailScreen(player: player),
            ),
          );
        },
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: $error'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(playerSearchProvider.notifier).loadActivePlayers();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
