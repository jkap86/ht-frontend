import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../leagues/application/leagues_provider.dart';
import 'league_form/dues_payouts_section.dart';

class AddLeagueModal extends StatelessWidget {
  const AddLeagueModal({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.85,
          constraints: const BoxConstraints(
            maxWidth: 800,
            maxHeight: 900,
          ),
          child: Column(
            children: [
              // Header with close button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Text(
                      'Add League',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              // Tab bar
              const TabBar(
                tabs: [
                  Tab(text: 'Public Leagues'),
                  Tab(text: 'Invites'),
                  Tab(text: 'Create League'),
                ],
              ),
              // Tab views
              Expanded(
                child: TabBarView(
                  children: [
                    _PublicLeaguesTab(),
                    _InvitesTab(),
                    _CreateLeagueTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PublicLeaguesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.public,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Public Leagues',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Browse and join public leagues',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Coming soon!',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InvitesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.mail_outline,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'League Invites',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'View and accept league invitations',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'No pending invites',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateLeagueTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_CreateLeagueTab> createState() => _CreateLeagueTabState();
}

class _CreateLeagueTabState extends ConsumerState<_CreateLeagueTab> {
  final _formKey = GlobalKey<FormState>();

  // Basic info
  final _nameController = TextEditingController();
  final _seasonController = TextEditingController(text: DateTime.now().year.toString());
  bool _isPublic = false;
  int _totalRosters = 12;
  String _seasonType = 'regular';

  // Schedule settings
  int _startWeek = 1;
  int _endWeek = 17;
  bool _playoffsEnabled = true;
  int _playoffWeekStart = 15;
  int _playoffTeams = 4;
  String _matchupType = 'head_to_head';

  // Scoring settings
  final Map<String, TextEditingController> _scoringControllers = {
    'passing_touchdowns': TextEditingController(text: '4'),
    'passing_yards': TextEditingController(text: '0.04'),
    'rushing_touchdowns': TextEditingController(text: '6'),
    'rushing_yards': TextEditingController(text: '0.1'),
    'receiving_touchdowns': TextEditingController(text: '6'),
    'receiving_yards': TextEditingController(text: '0.1'),
    'receiving_receptions': TextEditingController(text: '1'),
  };

  // Roster positions
  final Map<String, int> _rosterPositions = {
    'QB': 1,
    'RB': 2,
    'WR': 2,
    'TE': 1,
    'FLEX': 1,
    'SUPER_FLEX': 0,
    'K': 1,
    'DEF': 1,
    'BN': 6,
  };

  // Waiver settings
  String _waiverType = 'faab';
  int _faabBudget = 100;
  int _waiverPeriodDays = 2;
  String _processSchedule = 'daily';

  // Trade settings
  String _tradeNotificationSetting = 'proposer_choice';
  String _tradeDetailsSetting = 'proposer_choice';

  // Dues/Payouts settings
  double _entryFee = 0.0;
  List<Map<String, dynamic>> _payoutStructure = [];

  @override
  void dispose() {
    _nameController.dispose();
    _seasonController.dispose();
    for (var controller in _scoringControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Public/Private Toggle
            Card(
              child: SwitchListTile(
                title: Text(_isPublic ? 'Public League' : 'Private League'),
                subtitle: Text(
                  _isPublic
                      ? 'Anyone can find and join this league'
                      : 'Private - Invite only',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                value: _isPublic,
                onChanged: (value) => setState(() => _isPublic = value),
                secondary: Icon(_isPublic ? Icons.public : Icons.lock),
              ),
            ),
            const SizedBox(height: 16),

            // Section 1: Basic Settings
            _buildBasicSettingsSection(),
            const SizedBox(height: 16),

            // Section 2: Scoring Settings
            _buildScoringSettingsSection(),
            const SizedBox(height: 16),

            // Section 3: Roster Positions
            _buildRosterPositionsSection(),
            const SizedBox(height: 16),

            // Section 4: Waiver Settings
            _buildWaiverSettingsSection(),
            const SizedBox(height: 16),

            // Section 5: Trade Notification Settings
            _buildTradeNotificationSection(),
            const SizedBox(height: 16),

            // Section 6: Dues / Payouts
            DuesPayoutsSection(
              entryFee: _entryFee,
              payoutStructure: _payoutStructure,
              onEntryFeeChanged: (value) => setState(() => _entryFee = value),
              onPayoutStructureChanged: (value) => setState(() => _payoutStructure = value),
              totalRosters: _totalRosters,
              initiallyExpanded: false,
            ),
            const SizedBox(height: 24),

            // Create Button
            FilledButton.icon(
              onPressed: _handleCreateLeague,
              icon: const Icon(Icons.add),
              label: const Text('Create League'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicSettingsSection() {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        title: const Text('Basic League Information'),
        leading: const Icon(Icons.info_outline),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'League Name',
                    hintText: 'Enter league name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.sports_football),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a league name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _seasonController,
                  decoration: const InputDecoration(
                    labelText: 'Season',
                    hintText: 'YYYY',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a season year';
                    }
                    final year = int.tryParse(value);
                    if (year == null || year < 2020 || year > 2100) {
                      return 'Please enter a valid year (2020-2100)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildNumberSelector(
                  'Number of Teams',
                  _totalRosters,
                  2,
                  20,
                  (value) => setState(() => _totalRosters = value),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _seasonType,
                  decoration: const InputDecoration(
                    labelText: 'Season Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'regular', child: Text('Regular Season')),
                    DropdownMenuItem(value: 'offseason', child: Text('Offseason')),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _seasonType = value);
                  },
                ),
                const SizedBox(height: 16),
                _buildNumberSelector(
                  'Start Week',
                  _startWeek,
                  1,
                  18,
                  (value) => setState(() {
                    _startWeek = value;
                    if (_endWeek < _startWeek) _endWeek = _startWeek;
                    if (_playoffWeekStart <= _startWeek) {
                      _playoffWeekStart = _startWeek + 1;
                    }
                  }),
                ),
                const SizedBox(height: 16),
                _buildNumberSelector(
                  'End Week',
                  _endWeek,
                  _startWeek,
                  18,
                  (value) => setState(() {
                    _endWeek = value;
                    if (_playoffWeekStart > _endWeek) {
                      _playoffWeekStart = _endWeek;
                    }
                  }),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Enable Playoffs'),
                  value: _playoffsEnabled,
                  onChanged: (value) => setState(() => _playoffsEnabled = value),
                ),
                if (_playoffsEnabled) ...[
                  const SizedBox(height: 16),
                  _buildNumberSelector(
                    'Playoff Week Start',
                    _playoffWeekStart,
                    _startWeek + 1,
                    _endWeek,
                    (value) => setState(() => _playoffWeekStart = value),
                  ),
                  const SizedBox(height: 16),
                  _buildNumberSelector(
                    'Playoff Teams',
                    _playoffTeams,
                    2,
                    8,
                    (value) => setState(() => _playoffTeams = value),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoringSettingsSection() {
    return Card(
      child: ExpansionTile(
        title: const Text('Scoring Settings'),
        leading: const Icon(Icons.calculate),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildScoringField('Passing Touchdowns', 'passing_touchdowns'),
                const SizedBox(height: 12),
                _buildScoringField('Passing Yards (per yard)', 'passing_yards'),
                const SizedBox(height: 12),
                _buildScoringField('Rushing Touchdowns', 'rushing_touchdowns'),
                const SizedBox(height: 12),
                _buildScoringField('Rushing Yards (per yard)', 'rushing_yards'),
                const SizedBox(height: 12),
                _buildScoringField('Receiving Touchdowns', 'receiving_touchdowns'),
                const SizedBox(height: 12),
                _buildScoringField('Receiving Yards (per yard)', 'receiving_yards'),
                const SizedBox(height: 12),
                _buildScoringField('Receptions (PPR)', 'receiving_receptions'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRosterPositionsSection() {
    return Card(
      child: ExpansionTile(
        title: const Text('Roster Positions'),
        leading: const Icon(Icons.people),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                for (var entry in _rosterPositions.entries) ...[
                  _buildNumberSelector(
                    entry.key,
                    entry.value,
                    0,
                    10,
                    (value) => setState(() => _rosterPositions[entry.key] = value),
                  ),
                  if (entry.key != _rosterPositions.keys.last) const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaiverSettingsSection() {
    return Card(
      child: ExpansionTile(
        title: const Text('Waiver Settings'),
        leading: const Icon(Icons.swap_horiz),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _waiverType,
                  decoration: const InputDecoration(
                    labelText: 'Waiver Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'faab', child: Text('FAAB (Free Agent Budget)')),
                    DropdownMenuItem(value: 'rolling', child: Text('Rolling Waivers')),
                    DropdownMenuItem(value: 'reverse_standings', child: Text('Reverse Standings')),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _waiverType = value);
                  },
                ),
                if (_waiverType == 'faab') ...[
                  const SizedBox(height: 16),
                  _buildNumberSelector(
                    'FAAB Budget',
                    _faabBudget,
                    0,
                    1000,
                    (value) => setState(() => _faabBudget = value),
                  ),
                ],
                const SizedBox(height: 16),
                _buildNumberSelector(
                  'Waiver Period (Days)',
                  _waiverPeriodDays,
                  0,
                  7,
                  (value) => setState(() => _waiverPeriodDays = value),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _processSchedule,
                  decoration: const InputDecoration(
                    labelText: 'Process Schedule',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'daily', child: Text('Daily')),
                    DropdownMenuItem(value: 'tue_thu', child: Text('Tuesday & Thursday')),
                    DropdownMenuItem(value: 'wednesday', child: Text('Wednesday Only')),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _processSchedule = value);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradeNotificationSection() {
    return Card(
      child: ExpansionTile(
        title: const Text('Trade Notification Settings'),
        leading: const Icon(Icons.notifications),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _tradeNotificationSetting,
                  decoration: const InputDecoration(
                    labelText: 'Trade Notifications',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'proposer_choice', child: Text('Proposer Choice')),
                    DropdownMenuItem(value: 'always_notify', child: Text('Always Notify')),
                    DropdownMenuItem(value: 'never_notify', child: Text('Never Notify')),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _tradeNotificationSetting = value);
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _tradeDetailsSetting,
                  decoration: const InputDecoration(
                    labelText: 'Trade Details Visibility',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'proposer_choice', child: Text('Proposer Choice')),
                    DropdownMenuItem(value: 'always_show', child: Text('Always Show')),
                    DropdownMenuItem(value: 'never_show', child: Text('Never Show')),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _tradeDetailsSetting = value);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberSelector(
    String label,
    int value,
    int min,
    int max,
    ValueChanged<int> onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: value > min ? () => onChanged(value - 1) : null,
        ),
        SizedBox(
          width: 40,
          child: Text(
            '$value',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: value < max ? () => onChanged(value + 1) : null,
        ),
      ],
    );
  }

  Widget _buildScoringField(String label, String key) {
    return TextFormField(
      controller: _scoringControllers[key],
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
        if (double.tryParse(value) == null) {
          return 'Must be a number';
        }
        return null;
      },
    );
  }

  Future<void> _handleCreateLeague() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Build settings map
    final settings = {
      'is_public': _isPublic,
      'waiver_type': _waiverType,
      'faab_budget': _faabBudget,
      'waiver_period_days': _waiverPeriodDays,
      'process_schedule': _processSchedule,
      'trade_notification_setting': _tradeNotificationSetting,
      'trade_details_setting': _tradeDetailsSetting,
      'start_week': _startWeek,
      'end_week': _endWeek,
      'playoffs_enabled': _playoffsEnabled,
      'playoff_week_start': _playoffWeekStart,
      'playoff_teams': _playoffTeams,
      'dues': _entryFee,
      'payout_structure': _payoutStructure,
    };

    // Build scoring settings map
    final scoringSettings = {
      for (var entry in _scoringControllers.entries)
        entry.key: double.tryParse(entry.value.text) ?? 0.0,
    };

    // Show loading indicator
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Create league via provider
      await ref.read(myLeaguesProvider.notifier).addLeague(
            name: _nameController.text.trim(),
            season: _seasonController.text,
            totalRosters: _totalRosters,
            settings: settings,
            scoringSettings: scoringSettings,
            rosterPositions: _rosterPositions,
            seasonType: _seasonType,
          );

      // Close loading dialog
      if (!mounted) return;
      Navigator.of(context).pop();

      // Show success message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('League created successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Close the modal
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      // Close loading dialog
      if (!mounted) return;
      Navigator.of(context).pop();

      // Show error message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create league: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
