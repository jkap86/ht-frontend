import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/trade_provider.dart';
import '../../domain/trade.dart';
import '../../../drafts/application/drafts_provider.dart';
import '../../../dues_payouts/application/league_members_provider.dart';

class TradeProposalDialog extends ConsumerStatefulWidget {
  final int leagueId;
  final int userRosterId;

  const TradeProposalDialog({
    super.key,
    required this.leagueId,
    required this.userRosterId,
  });

  @override
  ConsumerState<TradeProposalDialog> createState() => _TradeProposalDialogState();
}

class _TradeProposalDialogState extends ConsumerState<TradeProposalDialog> {
  int? _selectedRecipientRosterId;
  final List<_PlayerSelection> _offeredPlayers = [];
  final List<_PlayerSelection> _requestedPlayers = [];
  final _notesController = TextEditingController();
  bool _isLoading = false;
  List<_PlayerSelection> _allPicks = [];
  bool _picksLoaded = false;
  bool _picksLoading = false;
  String? _loadError;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(leagueMembersProvider(widget.leagueId));
    final draftsAsync = ref.watch(leagueDraftsProvider(widget.leagueId));

    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.swap_horiz,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Propose Trade',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: membersAsync.when(
                data: (members) {
                  // Get other rosters (not the user's)
                  final otherRosters = members
                      .where((m) => m.rosterId != widget.userRosterId)
                      .toList();

                  return draftsAsync.when(
                    data: (drafts) {
                      // Find completed draft
                      final completedDraft = drafts.where((d) => d.status == 'completed').firstOrNull;

                      if (completedDraft == null) {
                        return const Center(child: Text('No completed draft found'));
                      }

                      // Load picks if not loaded
                      if (!_picksLoaded) {
                        _loadDraftPicks(completedDraft.id);
                      }

                      // My players
                      final myPlayers = _allPicks
                          .where((p) => p.rosterId == widget.userRosterId)
                          .toList();

                      // Selected recipient's players
                      final recipientPlayers = _selectedRecipientRosterId != null
                          ? _allPicks
                              .where((p) => p.rosterId == _selectedRecipientRosterId)
                              .toList()
                          : <_PlayerSelection>[];

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Select trade partner
                            Text(
                              'Trade Partner',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<int>(
                              value: _selectedRecipientRosterId,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              hint: const Text('Select a team...'),
                              items: otherRosters.map((m) {
                                return DropdownMenuItem<int>(
                                  value: m.rosterId,
                                  child: Text('${m.username} (Team ${m.rosterId})'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedRecipientRosterId = value;
                                  _requestedPlayers.clear();
                                });
                              },
                            ),

                            const SizedBox(height: 20),

                            // Two columns for trade
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Your players (offering)
                                Expanded(
                                  child: _buildPlayerColumn(
                                    title: 'You Send',
                                    color: Colors.red,
                                    icon: Icons.call_made,
                                    allPlayers: myPlayers,
                                    selectedPlayers: _offeredPlayers,
                                    onToggle: (player) {
                                      setState(() {
                                        if (_offeredPlayers.any((p) => p.playerId == player.playerId)) {
                                          _offeredPlayers.removeWhere((p) => p.playerId == player.playerId);
                                        } else {
                                          _offeredPlayers.add(player);
                                        }
                                      });
                                    },
                                  ),
                                ),

                                // Swap icon
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 40),
                                  child: Icon(
                                    Icons.swap_horiz,
                                    color: Theme.of(context).colorScheme.outline,
                                  ),
                                ),

                                // Their players (requesting)
                                Expanded(
                                  child: _buildPlayerColumn(
                                    title: 'You Receive',
                                    color: Colors.green,
                                    icon: Icons.call_received,
                                    allPlayers: recipientPlayers,
                                    selectedPlayers: _requestedPlayers,
                                    onToggle: _selectedRecipientRosterId == null
                                        ? null
                                        : (player) {
                                            setState(() {
                                              if (_requestedPlayers.any((p) => p.playerId == player.playerId)) {
                                                _requestedPlayers.removeWhere((p) => p.playerId == player.playerId);
                                              } else {
                                                _requestedPlayers.add(player);
                                              }
                                            });
                                          },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Notes
                            Text(
                              'Notes (optional)',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _notesController,
                              maxLines: 2,
                              decoration: InputDecoration(
                                hintText: 'Add a message to your trade partner...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.all(12),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, s) => Center(child: Text('Error: $e')),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Center(child: Text('Error: $e')),
              ),
            ),

            // Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _canSubmit() && !_isLoading ? _submitTrade : null,
                    child: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Propose Trade'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerColumn({
    required String title,
    required Color color,
    required IconData icon,
    required List<_PlayerSelection> allPlayers,
    required List<_PlayerSelection> selectedPlayers,
    required void Function(_PlayerSelection)? onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _picksLoading
              ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
              : _loadError != null
                  ? Center(
                      child: Text(
                        'Error: $_loadError',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    )
                  : allPlayers.isEmpty
                      ? Center(
                          child: Text(
                            onToggle == null ? 'Select a team first' : 'No players',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        )
                      : ListView.builder(
                  padding: const EdgeInsets.all(4),
                  itemCount: allPlayers.length,
                  itemBuilder: (context, index) {
                    final player = allPlayers[index];
                    final isSelected = selectedPlayers.any((p) => p.playerId == player.playerId);

                    return InkWell(
                      onTap: onToggle != null ? () => onToggle(player) : null,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 2),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? color.withValues(alpha: 0.15) : null,
                          borderRadius: BorderRadius.circular(4),
                          border: isSelected
                              ? Border.all(color: color.withValues(alpha: 0.5))
                              : null,
                        ),
                        child: Row(
                          children: [
                            if (isSelected)
                              Icon(Icons.check_circle, size: 16, color: color)
                            else
                              Icon(Icons.circle_outlined, size: 16, color: Theme.of(context).colorScheme.outline),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    player.playerName,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${player.position} - ${player.team}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Theme.of(context).colorScheme.outline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Future<void> _loadDraftPicks(int draftId) async {
    if (_picksLoaded || _picksLoading) return;

    setState(() {
      _picksLoading = true;
      _loadError = null;
    });

    final draftsApi = ref.read(draftsApiClientProvider);
    try {
      final picks = await draftsApi.getDraftPicks(widget.leagueId, draftId);
      debugPrint('Loaded ${picks.length} draft picks for league ${widget.leagueId}, draft $draftId');
      debugPrint('User roster ID: ${widget.userRosterId}');
      debugPrint('Roster IDs in picks: ${picks.map((p) => p.rosterId).toSet().toList()}');

      if (mounted) {
        setState(() {
          _allPicks = picks
              .where((p) => p.playerId != null)
              .map((p) => _PlayerSelection(
                    playerId: p.playerId!,
                    playerName: p.playerName ?? 'Unknown',
                    position: p.playerPosition ?? '',
                    team: p.playerTeam ?? 'FA',
                    rosterId: p.rosterId,
                  ))
              .toList();
          _picksLoaded = true;
          _picksLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading draft picks: $e');
      if (mounted) {
        setState(() {
          _loadError = e.toString();
          _picksLoading = false;
        });
      }
    }
  }

  bool _canSubmit() {
    return _selectedRecipientRosterId != null &&
        (_offeredPlayers.isNotEmpty || _requestedPlayers.isNotEmpty);
  }

  Future<void> _submitTrade() async {
    if (!_canSubmit()) return;

    setState(() => _isLoading = true);

    try {
      final request = ProposeTradeRequest(
        recipientRosterId: _selectedRecipientRosterId!,
        offeredPlayerIds: _offeredPlayers.map((p) => p.playerId).toList(),
        requestedPlayerIds: _requestedPlayers.map((p) => p.playerId).toList(),
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      await ref.read(tradesNotifierProvider(widget.leagueId).notifier).proposeTrade(request);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Trade proposal sent'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

class _PlayerSelection {
  final int playerId;
  final String playerName;
  final String position;
  final String team;
  final int rosterId;

  _PlayerSelection({
    required this.playerId,
    required this.playerName,
    required this.position,
    required this.team,
    required this.rosterId,
  });
}
