import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/waiver_provider.dart';
import '../../domain/waiver_claim.dart';

class AddPlayerDialog extends ConsumerStatefulWidget {
  final int leagueId;
  final AvailablePlayer player;
  final int userRosterId;

  const AddPlayerDialog({
    super.key,
    required this.leagueId,
    required this.player,
    required this.userRosterId,
  });

  @override
  ConsumerState<AddPlayerDialog> createState() => _AddPlayerDialogState();
}

class _AddPlayerDialogState extends ConsumerState<AddPlayerDialog> {
  int? _dropPlayerId;
  int _faabAmount = 0;
  bool _isLoading = false;
  final _faabController = TextEditingController();

  @override
  void dispose() {
    _faabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWaivers = widget.player.isOnWaivers;

    return AlertDialog(
      title: Text(isWaivers ? 'Submit Waiver Claim' : 'Add Free Agent'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Player being added
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.add_circle, color: Colors.green),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.player.playerName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${widget.player.position} - ${widget.player.team}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // FAAB bid (for waivers)
            if (isWaivers) ...[
              const SizedBox(height: 16),
              Text(
                'FAAB Bid Amount',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _faabController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixText: '\$ ',
                  hintText: '0',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onChanged: (value) {
                  setState(() {
                    _faabAmount = int.tryParse(value) ?? 0;
                  });
                },
              ),
            ],

            // Drop player (optional, would need roster data)
            const SizedBox(height: 16),
            Text(
              'Drop Player (optional)',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Select from your roster if needed to make room',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Waiver info
            if (isWaivers && widget.player.waiverClearsAt != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.schedule, color: Colors.orange, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Waivers process soon',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isWaivers ? 'Submit Claim' : 'Add Player'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);

    try {
      if (widget.player.isOnWaivers) {
        // Submit waiver claim
        final request = SubmitClaimRequest(
          playerId: widget.player.playerId,
          dropPlayerId: _dropPlayerId,
          faabAmount: _faabAmount,
        );
        await ref.read(waiversNotifierProvider(widget.leagueId).notifier).submitClaim(request);
      } else {
        // Add free agent directly
        await ref.read(freeAgentsNotifierProvider(widget.leagueId).notifier).addFreeAgent(
              widget.player.playerId,
              dropPlayerId: _dropPlayerId,
            );
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.player.isOnWaivers
                  ? 'Waiver claim submitted'
                  : '${widget.player.playerName} added to your roster',
            ),
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
