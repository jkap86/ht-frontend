import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/draft.dart';
import '../../application/drafts_provider.dart';
import 'settings/edit_draft_basic_settings_section.dart';
import 'settings/edit_draft_timer_settings_section.dart';
import 'settings/edit_draft_order_settings_section.dart';
import 'settings/edit_derby_settings_section.dart';

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
      _localDerbyOnTimeout = 'auto';
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
      _localDerbyOnTimeout = settings?.derbyOnTimeout ?? 'auto';
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
                  _localDerbyOnTimeout = 'auto';
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

          // Basic Settings
          EditDraftBasicSettingsSection(
            draftType: draftType,
            thirdRoundReversal: thirdRoundReversal,
            draftRounds: draftRounds,
            playerPool: playerPool,
            useRosterPositions: useRosterPositions,
            isCommissioner: isCommissioner,
            onDraftTypeChanged: onDraftTypeChanged,
            onThirdRoundReversalChanged: onThirdRoundReversalChanged,
            onDraftRoundsChanged: onDraftRoundsChanged,
            onPlayerPoolChanged: onPlayerPoolChanged,
          ),
          const SizedBox(height: 16),

          // Timer Settings
          EditDraftTimerSettingsSection(
            timerMode: timerMode,
            pickTimeSeconds: pickTimeSeconds,
            isCommissioner: isCommissioner,
            onTimerModeChanged: onTimerModeChanged,
            onPickTimeSecondsChanged: onPickTimeSecondsChanged,
          ),
          const SizedBox(height: 16),

          // Draft Order
          EditDraftOrderSettingsSection(
            draftOrder: draftOrder,
            isCommissioner: isCommissioner,
            onDraftOrderChanged: onDraftOrderChanged,
          ),

          // Derby Settings (shown when derby order is selected)
          if (draftOrder == 'derby')
            EditDerbySettingsSection(
              derbyTimerHours: derbyTimerHours,
              derbyTimerMinutes: derbyTimerMinutes,
              derbyTimerSeconds: derbyTimerSeconds,
              derbyOnTimeout: derbyOnTimeout,
              derbyStartTime: derbyStartTime,
              autoStartDerby: autoStartDerby,
              isCommissioner: isCommissioner,
              onDerbyTimerHoursChanged: onDerbyTimerHoursChanged,
              onDerbyTimerMinutesChanged: onDerbyTimerMinutesChanged,
              onDerbyTimerSecondsChanged: onDerbyTimerSecondsChanged,
              onDerbyOnTimeoutChanged: onDerbyOnTimeoutChanged,
              onDerbyStartTimeChanged: onDerbyStartTimeChanged,
              onAutoStartDerbyChanged: onAutoStartDerbyChanged,
            ),

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
