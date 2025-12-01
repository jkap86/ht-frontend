import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/league.dart';
import '../../domain/payout.dart';
import '../../application/league_members_provider.dart';
import '../../application/payouts_provider.dart';
import '../../../application/edit_league_controller.dart';

/// Editable dues and payouts section
class EditableDuesPayoutsSection extends ConsumerWidget {
  final Map<String, dynamic> settings;
  final Function(String, dynamic) onChanged;
  final League league;
  final bool? initiallyExpanded;
  final Function(bool)? onExpansionChanged;

  const EditableDuesPayoutsSection({
    super.key,
    required this.settings,
    required this.onChanged,
    required this.league,
    this.initiallyExpanded,
    this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dues = (settings['dues'] as num?)?.toDouble() ?? 0.0;
    final payoutsAsync = ref.watch(payoutsProvider(league.id));

    return Card(
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded ?? false,
        onExpansionChanged: onExpansionChanged,
        title: const Text(
          'Dues & Payouts',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Entry Fee
                TextFormField(
                  initialValue: dues > 0 ? dues.toStringAsFixed(2) : '0',
                  decoration: const InputDecoration(
                    labelText: 'Entry Fee',
                    border: OutlineInputBorder(),
                    prefixText: '\$ ',
                    helperText: 'Amount each member pays to join (0 for free)',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  onChanged: (value) {
                    onChanged('dues', double.tryParse(value) ?? 0.0);
                  },
                ),
                const SizedBox(height: 16),

                // Payouts Section
                _buildPayoutsSection(context, ref, payoutsAsync),

                // Quick calculator
                if (dues > 0) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    'Quick Calculator',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildPayoutCalculator(dues),
                ],

                // League Members section (only for commissioners)
                if (league.isCommissioner) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  _buildLeagueMembersSection(context, ref, dues),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayoutsSection(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Payout>> payoutsAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Payout Structure',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () => _showAddPayoutDialog(context, ref),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Payout'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        payoutsAsync.when(
          data: (payouts) {
            if (payouts.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'No payouts configured. Add payouts to define your prize structure.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              );
            }
            return _buildPayoutsList(context, ref, payouts);
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stack) => Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Error loading payouts: $error',
              style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPayoutsList(BuildContext context, WidgetRef ref, List<Payout> payouts) {
    // Group payouts by type
    final playoffPayouts = payouts.where((p) => p.type == PayoutType.playoffFinish).toList()
      ..sort((a, b) => a.place.compareTo(b.place));
    final regSeasonPayouts = payouts.where((p) => p.type == PayoutType.regSeasonPoints).toList()
      ..sort((a, b) => a.place.compareTo(b.place));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (playoffPayouts.isNotEmpty) ...[
          _buildPayoutTypeGroup(context, ref, 'Playoff Finish', playoffPayouts),
          const SizedBox(height: 8),
        ],
        if (regSeasonPayouts.isNotEmpty) ...[
          _buildPayoutTypeGroup(context, ref, 'Reg Season Points', regSeasonPayouts),
        ],
      ],
    );
  }

  Widget _buildPayoutTypeGroup(
    BuildContext context,
    WidgetRef ref,
    String title,
    List<Payout> payouts,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(7),
                topRight: Radius.circular(7),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  title.contains('Playoff') ? Icons.emoji_events : Icons.trending_up,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          ...payouts.map((payout) => _buildPayoutRow(context, ref, payout)),
        ],
      ),
    );
  }

  Widget _buildPayoutRow(BuildContext context, WidgetRef ref, Payout payout) {
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        radius: 14,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Text(
          '${payout.place}',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      title: Text(
        '${payout.displayPlace} Place',
        style: const TextStyle(fontSize: 13),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            payout.displayAmount,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.edit, size: 18),
            onPressed: () => _showEditPayoutDialog(context, ref, payout),
            tooltip: 'Edit',
          ),
          IconButton(
            icon: Icon(Icons.delete, size: 18, color: Theme.of(context).colorScheme.error),
            onPressed: () => _confirmDeletePayout(context, ref, payout),
            tooltip: 'Delete',
          ),
        ],
      ),
    );
  }

  void _showAddPayoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _PayoutDialog(
        leagueId: league.id,
        onSave: (type, place, amount) async {
          await ref.read(payoutsProvider(league.id).notifier).addPayout(
                type: type,
                place: place,
                amount: amount,
              );
        },
      ),
    );
  }

  void _showEditPayoutDialog(BuildContext context, WidgetRef ref, Payout payout) {
    showDialog(
      context: context,
      builder: (context) => _PayoutDialog(
        leagueId: league.id,
        existingPayout: payout,
        onSave: (type, place, amount) async {
          await ref.read(payoutsProvider(league.id).notifier).updatePayout(
                payout.id,
                type: type,
                place: place,
                amount: amount,
              );
        },
      ),
    );
  }

  void _confirmDeletePayout(BuildContext context, WidgetRef ref, Payout payout) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Payout'),
        content: Text(
          'Are you sure you want to delete the ${payout.displayPlace} place ${payout.displayType} payout (\$${payout.amount.toStringAsFixed(2)})?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(payoutsProvider(league.id).notifier).deletePayout(payout.id);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildPayoutCalculator(double dues) {
    // Assuming 12 teams by default - could be dynamic
    const teams = 12;
    final totalPot = dues * teams;

    return Builder(
      builder: (context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Pot: \$${totalPot.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Common splits:',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 4),
            _buildPayoutExample('1st: 60%, 2nd: 30%, 3rd: 10%', totalPot, [0.6, 0.3, 0.1]),
            _buildPayoutExample('1st: 70%, 2nd: 30%', totalPot, [0.7, 0.3]),
            _buildPayoutExample('1st: 50%, 2nd: 30%, 3rd: 20%', totalPot, [0.5, 0.3, 0.2]),
          ],
        ),
      ),
    );
  }

  Widget _buildPayoutExample(String label, double totalPot, List<double> percentages) {
    final payouts = percentages.map((p) => totalPot * p).toList();
    final payoutText = payouts.map((p) => '\$${p.toStringAsFixed(2)}').join(', ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        '$label = $payoutText',
        style: const TextStyle(fontSize: 11),
      ),
    );
  }

  Widget _buildLeagueMembersSection(BuildContext context, WidgetRef ref, double dues) {
    final membersAsync = ref.watch(leagueMembersProvider(league.id));
    final editState = ref.watch(editLeagueControllerProvider(league));
    final editController = ref.read(editLeagueControllerProvider(league).notifier);

    return ExpansionTile(
      title: const Text(
        'League Members',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      initiallyExpanded: false,
      children: [
        membersAsync.when(
          data: (members) {
            if (members.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'No members found',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                final isFreeLeague = dues == 0;

                // Check if there's a pending change for this member
                final hasPendingChange = editState.pendingPaymentChanges.containsKey(member.rosterId);
                final currentValue = hasPendingChange
                    ? editState.pendingPaymentChanges[member.rosterId]!
                    : member.paid;

                return SwitchListTile(
                  title: Text(member.username),
                  subtitle: Text('Roster ${member.rosterId}'),
                  value: currentValue,
                  // Disable toggle if league is free
                  onChanged: isFreeLeague ? null : (bool value) {
                    editController.updateMemberPaymentStatus(member.rosterId, value);
                  },
                  secondary: Icon(
                    currentValue ? Icons.check_circle : Icons.cancel,
                    color: currentValue ? Colors.green : Colors.grey,
                  ),
                );
              },
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Error loading members: $error',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ),
      ],
    );
  }
}

/// Dialog for adding/editing a payout
class _PayoutDialog extends StatefulWidget {
  final int leagueId;
  final Payout? existingPayout;
  final Future<void> Function(PayoutType type, int place, double amount) onSave;

  const _PayoutDialog({
    required this.leagueId,
    this.existingPayout,
    required this.onSave,
  });

  @override
  State<_PayoutDialog> createState() => _PayoutDialogState();
}

class _PayoutDialogState extends State<_PayoutDialog> {
  late PayoutType _selectedType;
  late TextEditingController _placeController;
  late TextEditingController _amountController;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.existingPayout?.type ?? PayoutType.playoffFinish;
    _placeController = TextEditingController(
      text: widget.existingPayout?.place.toString() ?? '1',
    );
    _amountController = TextEditingController(
      text: widget.existingPayout?.amount.toStringAsFixed(2) ?? '',
    );
  }

  @override
  void dispose() {
    _placeController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final place = int.tryParse(_placeController.text);
    final amount = double.tryParse(_amountController.text);

    if (place == null || place < 1 || place > 20) {
      setState(() => _error = 'Place must be between 1 and 20');
      return;
    }

    if (amount == null || amount < 0) {
      setState(() => _error = 'Amount must be a positive number');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await widget.onSave(_selectedType, place, amount);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingPayout != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Payout' : 'Add Payout'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_error != null)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _error!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    fontSize: 12,
                  ),
                ),
              ),

            // Payout Type
            const Text(
              'Payout Type',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<PayoutType>(
              value: _selectedType,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: PayoutType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Row(
                    children: [
                      Icon(
                        type == PayoutType.playoffFinish
                            ? Icons.emoji_events
                            : Icons.trending_up,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(type.displayName),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
            ),
            const SizedBox(height: 16),

            // Place
            const Text(
              'Place',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _placeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'e.g., 1 for 1st place',
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            const SizedBox(height: 16),

            // Amount
            const Text(
              'Amount',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixText: '\$ ',
                hintText: '0.00',
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _save,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isEditing ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}
