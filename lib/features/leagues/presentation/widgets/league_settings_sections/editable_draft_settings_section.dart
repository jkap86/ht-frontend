import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/draft.dart';
import '../../../application/drafts_provider.dart';

/// Editable draft settings section that uses the drafts API
class EditableDraftSettingsSection extends ConsumerStatefulWidget {
  final int leagueId;
  final Map<String, dynamic>? rosterPositions;
  final bool isCommissioner;

  const EditableDraftSettingsSection({
    super.key,
    required this.leagueId,
    this.rosterPositions,
    this.isCommissioner = false,
  });

  @override
  ConsumerState<EditableDraftSettingsSection> createState() => _EditableDraftSettingsSectionState();
}

class _EditableDraftSettingsSectionState extends ConsumerState<EditableDraftSettingsSection> {
  // Local draft state for editing
  String? _localDraftType;
  bool? _localThirdRoundReversal;
  int? _localDraftRounds;
  int? _localPickTimeSeconds;
  String? _localPlayerPool;
  String? _localDraftOrder;
  String? _localTimerMode;
  bool? _localUseRosterPositions;
  DateTime? _localDerbyStartTime;
  bool? _localAutoStartDerby;
  int? _localDerbyTimerHours;
  int? _localDerbyTimerMinutes;
  int? _localDerbyTimerSeconds;
  String? _localDerbyOnTimeout;
  bool _isDraftMode = false;
  int? _editingDraftId; // Track which draft ID is being edited

  void _startDraftMode() {
    setState(() {
      _isDraftMode = true;
      _editingDraftId = null;
      // Set defaults for new draft
      _localDraftType = 'snake';
      _localThirdRoundReversal = false;
      _localDraftRounds = 15;
      _localPickTimeSeconds = 90;
      _localPlayerPool = 'all';
      _localDraftOrder = 'randomize';
      _localTimerMode = 'per_pick';
      _localUseRosterPositions = false;
      _localDerbyStartTime = null;
      _localAutoStartDerby = false;
      _localDerbyTimerHours = 0;
      _localDerbyTimerMinutes = 5;
      _localDerbyTimerSeconds = 0;
      _localDerbyOnTimeout = 'skip';
    });
  }

  void _editDraft(Draft draft) {
    setState(() {
      _isDraftMode = true;
      _editingDraftId = draft.id;
      final settings = draft.settings;
      _localDraftType = draft.draftType;
      _localThirdRoundReversal = draft.thirdRoundReversal;
      _localDraftRounds = draft.rounds;
      _localPickTimeSeconds = draft.pickTimeSeconds;
      _localPlayerPool = settings?.playerPool ?? 'all';
      _localDraftOrder = settings?.draftOrder ?? 'randomize';
      _localTimerMode = 'per_pick'; // Default value - not in settings model yet
      _localUseRosterPositions = false; // Not stored in API yet
      _localDerbyStartTime = settings?.derbyStartTime;
      _localAutoStartDerby = false; // Default value - not in settings model yet

      // Derby timer fields
      final derbyTimerSeconds = settings?.derbyTimerSeconds ?? 300; // Default 5 minutes
      _localDerbyTimerHours = derbyTimerSeconds ~/ 3600;
      _localDerbyTimerMinutes = (derbyTimerSeconds % 3600) ~/ 60;
      _localDerbyTimerSeconds = derbyTimerSeconds % 60;
      _localDerbyOnTimeout = settings?.derbyOnTimeout ?? 'skip';
    });
  }

  Future<void> _saveDraft() async {
    final notifier = ref.read(draftsNotifierProvider(widget.leagueId).notifier);

    final draftData = <String, dynamic>{
      'draft_type': _localDraftType,
      'third_round_reversal': _localThirdRoundReversal,
      'rounds': _localDraftRounds,
      'pick_time_seconds': _localPickTimeSeconds,
      'player_pool': _localPlayerPool,
      'draft_order': _localDraftOrder,
      'timer_mode': _localTimerMode,
    };

    // Add derby-specific fields only if derby order is selected
    if (_localDraftOrder == 'derby') {
      if (_localDerbyStartTime != null) {
        draftData['derby_start_time'] = _localDerbyStartTime!.toIso8601String();
      }
      draftData['auto_start_derby'] = _localAutoStartDerby ?? false;

      // Calculate total derby timer in seconds
      final totalSeconds = (_localDerbyTimerHours ?? 0) * 3600 +
                          (_localDerbyTimerMinutes ?? 0) * 60 +
                          (_localDerbyTimerSeconds ?? 0);
      draftData['derby_timer_seconds'] = totalSeconds;
      draftData['derby_on_timeout'] = _localDerbyOnTimeout ?? 'skip';
    }

    try {
      if (_editingDraftId != null) {
        await notifier.updateDraft(_editingDraftId!, draftData);
      } else {
        await notifier.createDraft(draftData);
      }

      // Invalidate the leagueDraftsProvider to refresh the UI
      ref.invalidate(leagueDraftsProvider(widget.leagueId));

      setState(() {
        _isDraftMode = false;
        _editingDraftId = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_editingDraftId != null ? 'Draft updated' : 'Draft created'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _cancelDraft() {
    setState(() {
      _isDraftMode = false;
      _editingDraftId = null;
      _localDraftType = null;
      _localThirdRoundReversal = null;
      _localDraftRounds = null;
      _localPickTimeSeconds = null;
      _localPlayerPool = null;
      _localDraftOrder = null;
      _localTimerMode = null;
      _localUseRosterPositions = null;
      _localDerbyStartTime = null;
      _localAutoStartDerby = null;
      _localDerbyTimerHours = null;
      _localDerbyTimerMinutes = null;
      _localDerbyTimerSeconds = null;
      _localDerbyOnTimeout = null;
    });
  }

  Future<void> _deleteDraft(int draftId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Draft'),
        content: const Text('Are you sure you want to delete this draft?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final notifier = ref.read(draftsNotifierProvider(widget.leagueId).notifier);
      try {
        await notifier.deleteDraft(draftId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Draft deleted')),
          );
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting draft: $error'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  int _calculateTotalRosterPositions(Map<String, dynamic>? positions) {
    if (positions == null) return 15;
    int total = 0;
    for (final value in positions.values) {
      if (value is int) {
        total += value;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final draftsAsync = ref.watch(draftsNotifierProvider(widget.leagueId));

    return Card(
      child: ExpansionTile(
        initiallyExpanded: false,
        title: const Text(
          'Draft Settings',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: [
          // Create Draft button
          if (widget.isCommissioner && !_isDraftMode)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: _startDraftMode,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Create Draft'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
            ),

          // Show drafts or draft form
          if (!_isDraftMode)
            draftsAsync.when(
              data: (drafts) {
                if (drafts.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        'No drafts configured',
                        style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                      ),
                    ),
                  );
                }

                return Column(
                  children: drafts.reversed.map((draft) {
                    return _DraftSummaryCard(
                      draft: draft,
                      isCommissioner: widget.isCommissioner,
                      onEdit: () => _editDraft(draft),
                      onDelete: () => _deleteDraft(draft.id),
                    );
                  }).toList(),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stack) => Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'Error loading drafts: $error',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            )
          else
            _DraftConfigurationForm(
              draftType: _localDraftType ?? 'snake',
              thirdRoundReversal: _localThirdRoundReversal ?? false,
              draftRounds: _localDraftRounds ?? 15,
              pickTimeSeconds: _localPickTimeSeconds ?? 90,
              playerPool: _localPlayerPool ?? 'all',
              draftOrder: _localDraftOrder ?? 'randomize',
              timerMode: _localTimerMode ?? 'per_pick',
              useRosterPositions: _localUseRosterPositions ?? false,
              derbyStartTime: _localDerbyStartTime,
              autoStartDerby: _localAutoStartDerby ?? false,
              derbyTimerHours: _localDerbyTimerHours ?? 0,
              derbyTimerMinutes: _localDerbyTimerMinutes ?? 5,
              derbyTimerSeconds: _localDerbyTimerSeconds ?? 0,
              derbyOnTimeout: _localDerbyOnTimeout ?? 'skip',
              rosterPositions: widget.rosterPositions,
              isCommissioner: widget.isCommissioner,
              onDraftTypeChanged: (value) => setState(() => _localDraftType = value),
              onThirdRoundReversalChanged: (value) => setState(() => _localThirdRoundReversal = value),
              onDraftRoundsChanged: (value) => setState(() => _localDraftRounds = value),
              onPickTimeSecondsChanged: (value) => setState(() => _localPickTimeSeconds = value),
              onPlayerPoolChanged: (value) => setState(() => _localPlayerPool = value),
              onDraftOrderChanged: (value) => setState(() {
                _localDraftOrder = value;
                // Reset derby settings when switching away from derby
                if (value != 'derby') {
                  _localDerbyStartTime = null;
                  _localAutoStartDerby = false;
                  _localDerbyTimerHours = 0;
                  _localDerbyTimerMinutes = 5;
                  _localDerbyTimerSeconds = 0;
                  _localDerbyOnTimeout = 'skip';
                }
              }),
              onTimerModeChanged: (value) => setState(() => _localTimerMode = value),
              onDerbyStartTimeChanged: (value) => setState(() => _localDerbyStartTime = value),
              onAutoStartDerbyChanged: (value) => setState(() => _localAutoStartDerby = value),
              onDerbyTimerHoursChanged: (value) => setState(() => _localDerbyTimerHours = value),
              onDerbyTimerMinutesChanged: (value) => setState(() => _localDerbyTimerMinutes = value),
              onDerbyTimerSecondsChanged: (value) => setState(() => _localDerbyTimerSeconds = value),
              onDerbyOnTimeoutChanged: (value) => setState(() => _localDerbyOnTimeout = value),
              onUseRosterPositionsChanged: (value) {
                setState(() {
                  _localUseRosterPositions = value;
                  if (value) {
                    _localDraftRounds = _calculateTotalRosterPositions(widget.rosterPositions);
                  }
                });
              },
              onSaveDraft: _saveDraft,
              onCancelDraft: _cancelDraft,
            ),
        ],
      ),
    );
  }
}

/// Draft summary card widget
class _DraftSummaryCard extends StatelessWidget {
  final Draft draft;
  final bool isCommissioner;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _DraftSummaryCard({
    required this.draft,
    required this.isCommissioner,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatDraftType(String? type) {
    if (type == null) return 'Snake';
    return type == 'snake' ? 'Snake' : 'Linear';
  }

  String _formatPlayerPool(String? pool) {
    if (pool == null || pool == 'all') return 'All Players';
    if (pool == 'rookie') return 'Rookie Only';
    if (pool == 'vet') return 'Veteran Only';
    return pool;
  }

  @override
  Widget build(BuildContext context) {
    final settings = draft.settings;
    final draftType = draft.draftType;
    final rounds = draft.rounds;
    final playerPool = settings?.playerPool;
    final pickTimeSeconds = draft.pickTimeSeconds ?? 90;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        initiallyExpanded: false,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Theme.of(context).dividerColor),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Theme.of(context).dividerColor),
        ),
        leading: Icon(
          Icons.edit_note,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatDraftType(draftType),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$rounds Rounds • ${_formatPlayerPool(playerPool)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isCommissioner) ...[
              IconButton(
                icon: const Icon(Icons.edit, size: 18),
                onPressed: onEdit,
                tooltip: 'Edit',
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 18),
                onPressed: onDelete,
                tooltip: 'Delete',
                color: Colors.red,
              ),
            ],
          ],
        ),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailRow(label: 'Draft Type', value: _formatDraftType(draftType)),
              const SizedBox(height: 12),
              _DetailRow(label: 'Rounds', value: rounds.toString()),
              const SizedBox(height: 12),
              _DetailRow(label: 'Pick Time', value: '$pickTimeSeconds seconds'),
              const SizedBox(height: 12),
              _DetailRow(label: 'Player Pool', value: _formatPlayerPool(playerPool)),
              if (settings?.draftOrder != null) ...[
                const SizedBox(height: 12),
                _DetailRow(
                  label: 'Draft Order',
                  value: settings!.draftOrder == 'randomize' ? 'Randomize' : 'Derby',
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

/// Draft configuration form (reusing existing widget structure)
class _DraftConfigurationForm extends StatelessWidget {
  final String draftType;
  final bool thirdRoundReversal;
  final int draftRounds;
  final int pickTimeSeconds;
  final String playerPool;
  final String draftOrder;
  final String timerMode;
  final bool useRosterPositions;
  final DateTime? derbyStartTime;
  final bool autoStartDerby;
  final int derbyTimerHours;
  final int derbyTimerMinutes;
  final int derbyTimerSeconds;
  final String derbyOnTimeout;
  final Map<String, dynamic>? rosterPositions;
  final bool isCommissioner;
  final Function(String) onDraftTypeChanged;
  final Function(bool) onThirdRoundReversalChanged;
  final Function(int) onDraftRoundsChanged;
  final Function(int) onPickTimeSecondsChanged;
  final Function(String) onPlayerPoolChanged;
  final Function(String) onDraftOrderChanged;
  final Function(String) onTimerModeChanged;
  final Function(bool) onUseRosterPositionsChanged;
  final Function(DateTime?) onDerbyStartTimeChanged;
  final Function(bool) onAutoStartDerbyChanged;
  final Function(int) onDerbyTimerHoursChanged;
  final Function(int) onDerbyTimerMinutesChanged;
  final Function(int) onDerbyTimerSecondsChanged;
  final Function(String) onDerbyOnTimeoutChanged;
  final VoidCallback onSaveDraft;
  final VoidCallback onCancelDraft;

  const _DraftConfigurationForm({
    required this.draftType,
    required this.thirdRoundReversal,
    required this.draftRounds,
    required this.pickTimeSeconds,
    required this.playerPool,
    required this.draftOrder,
    required this.timerMode,
    required this.useRosterPositions,
    required this.derbyStartTime,
    required this.autoStartDerby,
    required this.derbyTimerHours,
    required this.derbyTimerMinutes,
    required this.derbyTimerSeconds,
    required this.derbyOnTimeout,
    this.rosterPositions,
    required this.isCommissioner,
    required this.onDraftTypeChanged,
    required this.onThirdRoundReversalChanged,
    required this.onDraftRoundsChanged,
    required this.onPickTimeSecondsChanged,
    required this.onPlayerPoolChanged,
    required this.onDraftOrderChanged,
    required this.onTimerModeChanged,
    required this.onUseRosterPositionsChanged,
    required this.onDerbyStartTimeChanged,
    required this.onAutoStartDerbyChanged,
    required this.onDerbyTimerHoursChanged,
    required this.onDerbyTimerMinutesChanged,
    required this.onDerbyTimerSecondsChanged,
    required this.onDerbyOnTimeoutChanged,
    required this.onSaveDraft,
    required this.onCancelDraft,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Draft mode indicator
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange),
            ),
            child: Row(
              children: [
                Icon(Icons.edit, size: 16, color: Colors.orange.shade900),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Editing draft settings - click Save to apply changes',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.shade900,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

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
            onChanged: isCommissioner ? (value) {
              if (value != null) onDraftTypeChanged(value);
            } : null,
          ),
          const SizedBox(height: 16),

          // Third Round Reversal
          if (draftType == 'snake')
            SwitchListTile(
              title: const Text('Third Round Reversal'),
              subtitle: const Text('Reverses the draft order on the 3rd round', style: TextStyle(fontSize: 12)),
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

          // Timer Mode
          DropdownButtonFormField<String>(
            value: timerMode,
            decoration: const InputDecoration(labelText: 'Timer Mode', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'per_pick', child: Text('Per Pick')),
              DropdownMenuItem(value: 'per_manager', child: Text('Per Manager')),
            ],
            onChanged: isCommissioner ? (value) {
              if (value != null) onTimerModeChanged(value);
            } : null,
          ),
          const SizedBox(height: 16),

          // Pick Time
          TextFormField(
            initialValue: pickTimeSeconds.toString(),
            decoration: const InputDecoration(
              labelText: 'Pick Time (seconds)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            enabled: isCommissioner,
            onChanged: (value) {
              final seconds = int.tryParse(value);
              if (seconds != null) onPickTimeSecondsChanged(seconds);
            },
          ),
          const SizedBox(height: 16),

          // Player Pool
          DropdownButtonFormField<String>(
            value: playerPool,
            decoration: const InputDecoration(labelText: 'Player Pool', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'all', child: Text('All Players')),
              DropdownMenuItem(value: 'rookie', child: Text('Rookie Only')),
              DropdownMenuItem(value: 'vet', child: Text('Veteran Only')),
            ],
            onChanged: isCommissioner ? (value) {
              if (value != null) onPlayerPoolChanged(value);
            } : null,
          ),
          const SizedBox(height: 16),

          // Draft Order
          DropdownButtonFormField<String>(
            value: draftOrder,
            decoration: const InputDecoration(labelText: 'Draft Order', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'randomize', child: Text('Randomize')),
              DropdownMenuItem(value: 'derby', child: Text('Derby')),
            ],
            onChanged: isCommissioner ? (value) {
              if (value != null) onDraftOrderChanged(value);
            } : null,
          ),

          // Derby countdown or notification (shown when derby order is selected)
          if (draftOrder == 'derby') ...[
            const SizedBox(height: 16),

            // Derby Timer
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Derby Timer',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: derbyTimerHours.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Hours',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        enabled: isCommissioner,
                        onChanged: (value) {
                          final hours = int.tryParse(value) ?? 0;
                          onDerbyTimerHoursChanged(hours);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        initialValue: derbyTimerMinutes.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Minutes',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        enabled: isCommissioner,
                        onChanged: (value) {
                          final minutes = int.tryParse(value) ?? 0;
                          onDerbyTimerMinutesChanged(minutes);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        initialValue: derbyTimerSeconds.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Seconds',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        enabled: isCommissioner,
                        onChanged: (value) {
                          final seconds = int.tryParse(value) ?? 0;
                          onDerbyTimerSecondsChanged(seconds);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // On Timeout
            DropdownButtonFormField<String>(
              value: derbyOnTimeout,
              decoration: const InputDecoration(
                labelText: 'On Timeout',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'skip', child: Text('Skip')),
                DropdownMenuItem(value: 'auto', child: Text('Auto')),
              ],
              onChanged: isCommissioner ? (value) {
                if (value != null) onDerbyOnTimeoutChanged(value);
              } : null,
            ),

            const SizedBox(height: 12),
            if (derbyStartTime != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.timer,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Derby starts in:',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(height: 4),
                          _DerbyCountdown(targetTime: derbyStartTime!),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.error.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Theme.of(context).colorScheme.error,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Derby start time not set',
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],

          // Derby-specific fields (only shown when derby order is selected)
          if (draftOrder == 'derby') ...[
            const SizedBox(height: 16),

            // Derby Start Time (optional)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Derby Start Time (Optional)'),
              subtitle: Text(
                derbyStartTime != null
                    ? '${derbyStartTime!.month}/${derbyStartTime!.day}/${derbyStartTime!.year} at ${derbyStartTime!.hour.toString().padLeft(2, '0')}:${derbyStartTime!.minute.toString().padLeft(2, '0')}'
                    : 'Not set',
                style: TextStyle(
                  fontSize: 14,
                  color: derbyStartTime != null
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (derbyStartTime != null)
                    IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: isCommissioner ? () => onDerbyStartTimeChanged(null) : null,
                      tooltip: 'Clear',
                    ),
                  FilledButton.tonalIcon(
                    onPressed: isCommissioner ? () async {
                      final now = DateTime.now();
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: derbyStartTime ?? now,
                        firstDate: now,
                        lastDate: now.add(const Duration(days: 365)),
                      );

                      if (selectedDate != null && context.mounted) {
                        final selectedTime = await showTimePicker(
                          context: context,
                          initialTime: derbyStartTime != null
                              ? TimeOfDay.fromDateTime(derbyStartTime!)
                              : TimeOfDay.now(),
                        );

                        if (selectedTime != null) {
                          final dateTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );
                          onDerbyStartTimeChanged(dateTime);
                        }
                      }
                    } : null,
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: const Text('Select'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Auto Start Derby toggle
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Auto Start Derby'),
              subtitle: const Text(
                'Automatically start the derby at the scheduled time',
                style: TextStyle(fontSize: 12),
              ),
              value: autoStartDerby,
              onChanged: isCommissioner ? onAutoStartDerbyChanged : null,
            ),
          ],

          // Action buttons
          if (isCommissioner) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onCancelDraft,
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: onSaveDraft,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Draft'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Derby countdown widget - shows time remaining until derby start
class _DerbyCountdown extends StatefulWidget {
  final DateTime targetTime;

  const _DerbyCountdown({required this.targetTime});

  @override
  State<_DerbyCountdown> createState() => _DerbyCountdownState();
}

class _DerbyCountdownState extends State<_DerbyCountdown> {
  late Duration _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        _updateRemaining();
      }
    });
  }

  @override
  void didUpdateWidget(_DerbyCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.targetTime != oldWidget.targetTime) {
      _updateRemaining();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateRemaining() {
    setState(() {
      // Convert target time to local timezone before comparing with DateTime.now()
      _remaining = widget.targetTime.toLocal().difference(DateTime.now());
    });
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) {
      return 'Started ${_formatPositiveDuration(duration.abs())} ago';
    }
    return _formatPositiveDuration(duration);
  }

  String _formatPositiveDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (days > 0) {
      return '$days day${days != 1 ? 's' : ''}, ${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  Color _getTextColor() {
    if (_remaining.isNegative) {
      return Colors.red;
    } else if (_remaining.inHours < 1) {
      return Colors.orange;
    } else {
      return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDuration(_remaining),
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: _getTextColor(),
      ),
    );
  }
}
