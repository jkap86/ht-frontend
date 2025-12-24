import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/draft.dart';
import '../../application/drafts_provider.dart';
import 'edit_draft_settings_form.dart';
import 'components/draft_summary_card.dart';
import 'components/empty_drafts_message.dart';

/// Editable draft settings section that uses the drafts API
class EditableDraftSettingsSection extends ConsumerStatefulWidget {
  final int leagueId;
  final Map<String, dynamic>? rosterPositions;
  final bool isCommissioner;
  final bool? initiallyExpanded;
  final Function(bool)? onExpansionChanged;

  const EditableDraftSettingsSection({
    super.key,
    required this.leagueId,
    this.rosterPositions,
    this.isCommissioner = false,
    this.initiallyExpanded,
    this.onExpansionChanged,
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
      _localDraftOrder = 'random';
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
      _localDraftOrder = settings?.draftOrder ?? 'random';
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

    // Structure the draft data according to backend schema
    final draftData = <String, dynamic>{
      'draft_type': _localDraftType,
      'rounds': _localDraftRounds,
      'third_round_reversal': _localThirdRoundReversal ?? false,
      'player_pool': _localPlayerPool ?? 'all',
      'settings': {
        'pick_time_seconds': _localPickTimeSeconds ?? 90,
        'draft_order': _localDraftOrder ?? 'random',
        'timer_mode': _localTimerMode ?? 'per_pick',
        'player_pool': _localPlayerPool ?? 'all',  // Also in settings for backward compatibility
      },
    };

    // Add derby-specific fields only if derby order is selected
    if (_localDraftOrder == 'derby') {
      final derbySettings = <String, dynamic>{};

      if (_localDerbyStartTime != null) {
        derbySettings['derby_start_time'] = _localDerbyStartTime!.toIso8601String();
      }

      // Calculate total derby timer in seconds
      final totalSeconds = (_localDerbyTimerHours ?? 0) * 3600 +
                          (_localDerbyTimerMinutes ?? 0) * 60 +
                          (_localDerbyTimerSeconds ?? 0);

      if (totalSeconds > 0) {
        // Convert to hours and round up to minimum of 1 hour
        final hours = (totalSeconds / 3600).ceil();
        derbySettings['derby_duration_hours'] = hours < 1 ? 1 : hours;
        // Also send the exact seconds for backwards compatibility
        derbySettings['derby_timer_seconds'] = totalSeconds;
      } else {
        // Default to 5 minutes if no timer is set
        derbySettings['derby_timer_seconds'] = 300;
        derbySettings['derby_duration_hours'] = 1;
      }

      derbySettings['auto_assign_remaining'] = _localDerbyOnTimeout == 'auto' ? true : false;

      draftData['derby_settings'] = derbySettings;
      draftData['auto_start'] = _localAutoStartDerby ?? false;
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
        initiallyExpanded: widget.initiallyExpanded ?? false,
        onExpansionChanged: widget.onExpansionChanged,
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
                  return const EmptyDraftsMessage();
                }

                return Column(
                  children: drafts.reversed.map((draft) {
                    return DraftSummaryCard(
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
            EditDraftSettingsForm(
              draftType: _localDraftType ?? 'snake',
              thirdRoundReversal: _localThirdRoundReversal ?? false,
              draftRounds: _localDraftRounds ?? 15,
              pickTimeSeconds: _localPickTimeSeconds ?? 90,
              playerPool: _localPlayerPool ?? 'all',
              draftOrder: _localDraftOrder ?? 'random',
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
