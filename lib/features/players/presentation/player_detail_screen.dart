import 'package:flutter/material.dart';
import '../domain/player.dart';

class PlayerDetailScreen extends StatelessWidget {
  final Player player;

  const PlayerDetailScreen({
    super.key,
    required this.player,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(player.fullName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildSection('Basic Info', [
              _buildInfoRow('Position', player.displayPosition),
              _buildInfoRow('Team', player.displayTeam),
              if (player.number != null) _buildInfoRow('Number', '#${player.number}'),
              if (player.status != null) _buildInfoRow('Status', player.status!),
              if (player.injuryStatus != null)
                _buildInfoRow('Injury Status', player.injuryStatus!),
              if (player.age != null) _buildInfoRow('Age', '${player.age}'),
            ]),
            const SizedBox(height: 24),
            _buildSection('Career', [
              if (player.yearsExp != null)
                _buildInfoRow('Experience', '${player.yearsExp} years'),
              if (player.isRookie)
                const Chip(
                  label: Text('Rookie'),
                  backgroundColor: Colors.green,
                  labelStyle: TextStyle(color: Colors.white),
                ),
            ]),
            const SizedBox(height: 24),
            _buildSection('Fantasy Positions', [
              _buildInfoRow(
                'Eligible Positions',
                player.fantasyPositions.join(', '),
              ),
            ]),
            const SizedBox(height: 24),
            _buildSection('Technical Info', [
              _buildInfoRow('Player ID', '${player.id}'),
              _buildInfoRow('Sleeper ID', player.sleeperId),
              if (player.active != null)
                _buildInfoRow('Active', player.active! ? 'Yes' : 'No'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                player.displayPosition,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.fullName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${player.displayPosition} - ${player.displayTeam}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
