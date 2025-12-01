import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/league.dart';
import '../../domain/payout.dart';
import '../../application/league_members_provider.dart';
import '../../application/payouts_provider.dart';
import '../../../application/edit_league_controller.dart';

/// Editable dues and payouts section
class EditableDuesPayoutsSection extends ConsumerStatefulWidget {
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
  ConsumerState<EditableDuesPayoutsSection> createState() => _EditableDuesPayoutsSectionState();
}

class _EditableDuesPayoutsSectionState extends ConsumerState<EditableDuesPayoutsSection> {
  // Inline add form controllers
  PayoutType _newPayoutType = PayoutType.playoffFinish;
  final TextEditingController _newPlaceController = TextEditingController(text: '1');
  final TextEditingController _newAmountController = TextEditingController();
  String? _addError;

  // Editing state
  String? _editingPayoutId;
  PayoutType? _editPayoutType;
  final TextEditingController _editPlaceController = TextEditingController();
  final TextEditingController _editAmountController = TextEditingController();
  String? _editError;

  @override
  void dispose() {
    _newPlaceController.dispose();
    _newAmountController.dispose();
    _editPlaceController.dispose();
    _editAmountController.dispose();
    super.dispose();
  }

  void _addPayout() {
    final place = int.tryParse(_newPlaceController.text);
    final amount = double.tryParse(_newAmountController.text);

    if (place == null || place < 1 || place > 20) {
      setState(() => _addError = 'Place: 1-20');
      return;
    }
    if (amount == null || amount <= 0) {
      setState(() => _addError = 'Enter amount');
      return;
    }

    // Stage the payout addition in the controller
    final error = ref.read(editLeagueControllerProvider(widget.league).notifier).addPayout(
      type: _newPayoutType,
      place: place,
      amount: amount,
    );

    if (error != null) {
      setState(() => _addError = error);
      return;
    }

    setState(() => _addError = null);

    // Reset form
    _newPlaceController.text = '1';
    _newAmountController.clear();
  }

  void _startEditing(Payout payout) {
    setState(() {
      _editingPayoutId = payout.id;
      _editPayoutType = payout.type;
      _editPlaceController.text = payout.place.toString();
      _editAmountController.text = payout.amount.toStringAsFixed(2);
      _editError = null;
    });
  }

  void _cancelEditing() {
    setState(() {
      _editingPayoutId = null;
      _editPayoutType = null;
      _editPlaceController.clear();
      _editAmountController.clear();
      _editError = null;
    });
  }

  void _saveEdit(String payoutId) {
    final place = int.tryParse(_editPlaceController.text);
    final amount = double.tryParse(_editAmountController.text);

    if (place == null || place < 1 || place > 20) {
      setState(() => _editError = 'Place: 1-20');
      return;
    }
    if (amount == null || amount <= 0) {
      setState(() => _editError = 'Enter amount');
      return;
    }

    // Stage the payout update in the controller
    final error = ref.read(editLeagueControllerProvider(widget.league).notifier).updatePayout(
      payoutId,
      type: _editPayoutType,
      place: place,
      amount: amount,
    );

    if (error != null) {
      setState(() => _editError = error);
      return;
    }

    _cancelEditing();
  }

  void _deletePayout(Payout payout) {
    // Stage the payout deletion in the controller
    ref.read(editLeagueControllerProvider(widget.league).notifier).deletePayout(payout.id);
  }

  @override
  Widget build(BuildContext context) {
    final dues = (widget.settings['dues'] as num?)?.toDouble() ?? 0.0;
    final editState = ref.watch(editLeagueControllerProvider(widget.league));
    final editController = ref.read(editLeagueControllerProvider(widget.league).notifier);
    final payoutsAsync = ref.watch(payoutsProvider(widget.league.id));

    // Initialize original payouts from server when they load
    ref.listen(payoutsProvider(widget.league.id), (previous, next) {
      next.whenData((payouts) {
        editController.setOriginalPayouts(payouts);
      });
    });

    // Also check on first build
    payoutsAsync.whenData((payouts) {
      if (editState.originalPayouts.isEmpty && payouts.isNotEmpty) {
        // Use addPostFrameCallback to avoid calling during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          editController.setOriginalPayouts(payouts);
        });
      }
    });

    // Use edited payouts from local state (falls back to server data while loading)
    final payouts = editState.originalPayouts.isNotEmpty
        ? editState.editedPayouts
        : payoutsAsync.valueOrNull ?? [];
    final isLoading = payoutsAsync.isLoading && editState.originalPayouts.isEmpty;

    return Card(
      child: ExpansionTile(
        initiallyExpanded: widget.initiallyExpanded ?? false,
        onExpansionChanged: widget.onExpansionChanged,
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
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  onChanged: (value) {
                    widget.onChanged('dues', double.tryParse(value) ?? 0.0);
                  },
                ),
                const SizedBox(height: 16),

                // Payouts Section
                _buildPayoutsSection(context, payouts, isLoading),

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
                if (widget.league.isCommissioner) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  _buildLeagueMembersSection(context, dues),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayoutsSection(BuildContext context, List<Payout> payouts, bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payout Structure',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        // Inline Add Form
        _buildInlineAddForm(context),
        const SizedBox(height: 12),

        if (isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          )
        else if (payouts.isEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'No payouts configured yet.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPayoutsList(context, payouts),
              const SizedBox(height: 12),
              _buildAllocationStatus(context, payouts),
            ],
          ),
      ],
    );
  }

  Widget _buildInlineAddForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.add_circle, size: 16, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Add Payout',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type dropdown
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<PayoutType>(
                  value: _newPayoutType,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    isDense: true,
                  ),
                  items: PayoutType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(
                        type == PayoutType.playoffFinish ? 'Playoff' : 'Reg Season',
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _newPayoutType = value);
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              // Place input
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _newPlaceController,
                  decoration: const InputDecoration(
                    labelText: 'Place',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    isDense: true,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              const SizedBox(width: 8),
              // Amount input
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: _newAmountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(),
                    prefixText: '\$ ',
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    isDense: true,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              const SizedBox(width: 8),
              // Add button
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: _addPayout,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    minimumSize: const Size(50, 40),
                  ),
                  child: const Icon(Icons.add, size: 20),
                ),
              ),
            ],
          ),
          if (_addError != null) ...[
            const SizedBox(height: 4),
            Text(
              _addError!,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAllocationStatus(BuildContext context, List<Payout> payouts) {
    final dues = (widget.settings['dues'] as num?)?.toDouble() ?? 0.0;
    final totalRosters = widget.league.totalRosters;
    final totalPot = dues * totalRosters;
    final totalAllocated = payouts.fold<double>(0, (sum, p) => sum + p.amount);

    const tolerance = 0.01;
    final difference = totalAllocated - totalPot;
    final isFullyAllocated = difference.abs() < tolerance;
    final isUnderAllocated = totalAllocated < totalPot - tolerance;
    final isOverAllocated = totalAllocated > totalPot + tolerance;

    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (dues == 0 && totalAllocated > 0) {
      statusColor = Theme.of(context).colorScheme.error;
      statusIcon = Icons.error;
      statusText = 'Entry fee is \$0 but payouts are configured';
    } else if (dues == 0) {
      statusColor = Colors.grey;
      statusIcon = Icons.info_outline;
      statusText = 'Free league - no payouts needed';
    } else if (isFullyAllocated) {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
      statusText = 'Fully allocated';
    } else if (isUnderAllocated) {
      final remaining = totalPot - totalAllocated;
      statusColor = Colors.orange;
      statusIcon = Icons.warning;
      statusText = 'Under-allocated by \$${remaining.toStringAsFixed(2)}';
    } else {
      final over = totalAllocated - totalPot;
      statusColor = Theme.of(context).colorScheme.error;
      statusIcon = Icons.error;
      statusText = 'Over-allocated by \$${over.toStringAsFixed(2)}';
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        border: Border.all(color: statusColor.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(statusIcon, size: 18, color: statusColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          if (dues > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Pot ($totalRosters teams x \$${dues.toStringAsFixed(2)}):',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  '\$${totalPot.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Allocated:',
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  '\$${totalAllocated.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isFullyAllocated ? Colors.green : (isOverAllocated ? Theme.of(context).colorScheme.error : Colors.orange),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPayoutsList(BuildContext context, List<Payout> payouts) {
    final playoffPayouts = payouts.where((p) => p.type == PayoutType.playoffFinish).toList()
      ..sort((a, b) => a.place.compareTo(b.place));
    final regSeasonPayouts = payouts.where((p) => p.type == PayoutType.regSeasonPoints).toList()
      ..sort((a, b) => a.place.compareTo(b.place));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (playoffPayouts.isNotEmpty) ...[
          _buildPayoutTypeGroup(context, 'Playoff Finish', playoffPayouts),
          const SizedBox(height: 8),
        ],
        if (regSeasonPayouts.isNotEmpty) ...[
          _buildPayoutTypeGroup(context, 'Reg Season Points', regSeasonPayouts),
        ],
      ],
    );
  }

  Widget _buildPayoutTypeGroup(BuildContext context, String title, List<Payout> payouts) {
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
          ...payouts.map((payout) => _buildPayoutRow(context, payout)),
        ],
      ),
    );
  }

  Widget _buildPayoutRow(BuildContext context, Payout payout) {
    final isEditing = _editingPayoutId == payout.id;

    if (isEditing) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Type dropdown
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<PayoutType>(
                    value: _editPayoutType,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                      isDense: true,
                    ),
                    items: PayoutType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(
                          type == PayoutType.playoffFinish ? 'Playoff' : 'Reg',
                          style: const TextStyle(fontSize: 11),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _editPayoutType = value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 6),
                // Place
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: _editPlaceController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(width: 6),
                // Amount
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _editAmountController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixText: '\$',
                      contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                      isDense: true,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(width: 4),
                // Save/Cancel buttons
                IconButton(
                  icon: const Icon(Icons.check, size: 18, color: Colors.green),
                  onPressed: () => _saveEdit(payout.id),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                  onPressed: _cancelEditing,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
            if (_editError != null) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  _editError!,
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              '${payout.place}',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${payout.displayPlace} Place',
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Text(
            payout.displayAmount,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.edit, size: 16),
            onPressed: () => _startEditing(payout),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            tooltip: 'Edit',
          ),
          IconButton(
            icon: Icon(Icons.delete, size: 16, color: Theme.of(context).colorScheme.error),
            onPressed: () => _deletePayout(payout),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            tooltip: 'Delete',
          ),
        ],
      ),
    );
  }

  Widget _buildPayoutCalculator(double dues) {
    final teams = widget.league.totalRosters;
    final totalPot = dues * teams;

    return Container(
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

  Widget _buildLeagueMembersSection(BuildContext context, double dues) {
    final membersAsync = ref.watch(leagueMembersProvider(widget.league.id));
    final editState = ref.watch(editLeagueControllerProvider(widget.league));
    final editController = ref.read(editLeagueControllerProvider(widget.league).notifier);

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

                final hasPendingChange = editState.pendingPaymentChanges.containsKey(member.rosterId);
                final currentValue = hasPendingChange
                    ? editState.pendingPaymentChanges[member.rosterId]!
                    : member.paid;

                return SwitchListTile(
                  title: Text(member.username),
                  subtitle: Text('Roster ${member.rosterId}'),
                  value: currentValue,
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
