import 'dart:async';
import 'package:flutter/material.dart';
import '../../../domain/league_creation_data.dart';

/// Draft settings section for create league - manages local draft configurations
class CreateDraftSettingsSection extends StatefulWidget {
  final LeagueCreationData data;
  final Function(List<Map<String, dynamic>>) onDraftConfigurationsChanged;
  final Map<String, dynamic>? rosterPositions;

  const CreateDraftSettingsSection({
    super.key,
    required this.data,
    required this.onDraftConfigurationsChanged,
    this.rosterPositions,
  });

  @override
  State<CreateDraftSettingsSection> createState() => _CreateDraftSettingsSectionState();
}

class _CreateDraftSettingsSectionState extends State<CreateDraftSettingsSection> {
  bool _isDraftMode = false;
  int? _editingIndex;

  // Local draft state for editing
  String _localDraftType = 'snake';
  bool _localThirdRoundReversal = false;
  int _localDraftRounds = 15;
  int _localPickTimeSeconds = 90;
  String _localPlayerPool = 'all';
  String _localDraftOrder = 'randomize';
  String _localTimerMode = 'per_pick';
  DateTime? _localDerbyStartTime;
  bool _localAutoStartDerby = false;

  void _startDraftMode() {
    setState(() {
      _isDraftMode = true;
      _editingIndex = null;
      _localDraftType = 'snake';
      _localThirdRoundReversal = false;
      _localDraftRounds = 15;
      _localPickTimeSeconds = 90;
      _localPlayerPool = 'all';
      _localDraftOrder = 'randomize';
      _localTimerMode = 'per_pick';
      _localDerbyStartTime = null;
      _localAutoStartDerby = false;
    });
  }

  void _editDraft(int index) {
    final draft = widget.data.draftConfigurations[index];
    setState(() {
      _isDraftMode = true;
      _editingIndex = index;
      _localDraftType = draft['draft_type'] as String? ?? 'snake';
      _localThirdRoundReversal = draft['third_round_reversal'] as bool? ?? false;
      _localDraftRounds = draft['rounds'] as int? ?? 15;
      _localPickTimeSeconds = draft['pick_time_seconds'] as int? ?? 90;
      _localPlayerPool = draft['player_pool'] as String? ?? 'all';
      _localDraftOrder = draft['draft_order'] as String? ?? 'randomize';
      _localTimerMode = draft['timer_mode'] as String? ?? 'per_pick';

      // Parse derby start time if present
      final derbyStartTimeStr = draft['derby_start_time'] as String?;
      _localDerbyStartTime = derbyStartTimeStr != null ? DateTime.tryParse(derbyStartTimeStr) : null;
      _localAutoStartDerby = draft['auto_start_derby'] as bool? ?? false;
    });
  }

  void _saveDraft() {
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
      draftData['auto_start_derby'] = _localAutoStartDerby;
    }

    final updatedConfigurations = [...widget.data.draftConfigurations];
    if (_editingIndex != null) {
      updatedConfigurations[_editingIndex!] = draftData;
    } else {
      updatedConfigurations.add(draftData);
    }

    widget.onDraftConfigurationsChanged(updatedConfigurations);

    setState(() {
      _isDraftMode = false;
      _editingIndex = null;
    });
  }

  void _cancelDraft() {
    setState(() {
      _isDraftMode = false;
      _editingIndex = null;
    });
  }

  void _deleteDraft(int index) {
    final updatedConfigurations = [...widget.data.draftConfigurations];
    updatedConfigurations.removeAt(index);
    widget.onDraftConfigurationsChanged(updatedConfigurations);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: false,
        title: const Text(
          'Draft Settings',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: [
          // Create Draft button
          if (!_isDraftMode)
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
          if (!_isDraftMode && widget.data.draftConfigurations.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'No drafts configured',
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
              ),
            ),

          if (!_isDraftMode && widget.data.draftConfigurations.isNotEmpty)
            ...widget.data.draftConfigurations.asMap().entries.map((entry) {
              final index = entry.key;
              final draft = entry.value;
              return _DraftSummaryCard(
                draft: draft,
                onEdit: () => _editDraft(index),
                onDelete: () => _deleteDraft(index),
              );
            }).toList(),

          if (_isDraftMode)
            _DraftConfigurationForm(
              draftType: _localDraftType,
              thirdRoundReversal: _localThirdRoundReversal,
              draftRounds: _localDraftRounds,
              pickTimeSeconds: _localPickTimeSeconds,
              playerPool: _localPlayerPool,
              draftOrder: _localDraftOrder,
              timerMode: _localTimerMode,
              derbyStartTime: _localDerbyStartTime,
              autoStartDerby: _localAutoStartDerby,
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
                }
              }),
              onTimerModeChanged: (value) => setState(() => _localTimerMode = value),
              onDerbyStartTimeChanged: (value) => setState(() => _localDerbyStartTime = value),
              onAutoStartDerbyChanged: (value) => setState(() => _localAutoStartDerby = value),
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
  final Map<String, dynamic> draft;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _DraftSummaryCard({
    required this.draft,
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
    final draftType = draft['draft_type'] as String?;
    final rounds = draft['rounds'] as int? ?? 15;
    final playerPool = draft['player_pool'] as String?;
    final pickTimeSeconds = draft['pick_time_seconds'] as int? ?? 90;

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
              if (draft['draft_order'] != null) ...[
                const SizedBox(height: 12),
                _DetailRow(
                  label: 'Draft Order',
                  value: draft['draft_order'] == 'randomize' ? 'Randomize' : 'Derby',
                ),
              ],
              if (draft['timer_mode'] != null) ...[
                const SizedBox(height: 12),
                _DetailRow(
                  label: 'Timer Mode',
                  value: draft['timer_mode'] == 'per_pick' ? 'Per Pick' : 'Per Manager',
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
      _remaining = widget.targetTime.difference(DateTime.now());
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

/// Draft configuration form
class _DraftConfigurationForm extends StatelessWidget {
  final String draftType;
  final bool thirdRoundReversal;
  final int draftRounds;
  final int pickTimeSeconds;
  final String playerPool;
  final String draftOrder;
  final String timerMode;
  final DateTime? derbyStartTime;
  final bool autoStartDerby;
  final Function(String) onDraftTypeChanged;
  final Function(bool) onThirdRoundReversalChanged;
  final Function(int) onDraftRoundsChanged;
  final Function(int) onPickTimeSecondsChanged;
  final Function(String) onPlayerPoolChanged;
  final Function(String) onDraftOrderChanged;
  final Function(String) onTimerModeChanged;
  final Function(DateTime?) onDerbyStartTimeChanged;
  final Function(bool) onAutoStartDerbyChanged;
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
    required this.derbyStartTime,
    required this.autoStartDerby,
    required this.onDraftTypeChanged,
    required this.onThirdRoundReversalChanged,
    required this.onDraftRoundsChanged,
    required this.onPickTimeSecondsChanged,
    required this.onPlayerPoolChanged,
    required this.onDraftOrderChanged,
    required this.onTimerModeChanged,
    required this.onDerbyStartTimeChanged,
    required this.onAutoStartDerbyChanged,
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
            onChanged: (value) {
              if (value != null) onDraftTypeChanged(value);
            },
          ),
          const SizedBox(height: 16),

          // Third Round Reversal
          if (draftType == 'snake')
            SwitchListTile(
              title: const Text('Third Round Reversal'),
              subtitle: const Text('Reverses the draft order on the 3rd round', style: TextStyle(fontSize: 12)),
              value: thirdRoundReversal,
              onChanged: onThirdRoundReversalChanged,
            ),

          const SizedBox(height: 16),

          // Draft Rounds
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  key: ValueKey('draft_rounds_$draftRounds'),
                  initialValue: draftRounds.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Draft Rounds',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final rounds = int.tryParse(value);
                    if (rounds != null) onDraftRoundsChanged(rounds);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  initialValue: pickTimeSeconds.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Pick Time (seconds)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final seconds = int.tryParse(value);
                    if (seconds != null) onPickTimeSecondsChanged(seconds);
                  },
                ),
              ),
            ],
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
            onChanged: (value) {
              if (value != null) onPlayerPoolChanged(value);
            },
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
            onChanged: (value) {
              if (value != null) onDraftOrderChanged(value);
            },
          ),

          // Derby countdown or notification (shown when derby order is selected)
          if (draftOrder == 'derby') ...[
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

          const SizedBox(height: 16),

          // Timer Mode
          DropdownButtonFormField<String>(
            value: timerMode,
            decoration: const InputDecoration(labelText: 'Timer Mode', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'per_pick', child: Text('Per Pick')),
              DropdownMenuItem(value: 'per_manager', child: Text('Per Manager')),
            ],
            onChanged: (value) {
              if (value != null) onTimerModeChanged(value);
            },
          ),

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
                      onPressed: () => onDerbyStartTimeChanged(null),
                      tooltip: 'Clear',
                    ),
                  FilledButton.tonalIcon(
                    onPressed: () async {
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
                    },
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
              onChanged: onAutoStartDerbyChanged,
            ),
          ],

          // Action buttons
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
      ),
    );
  }
}
