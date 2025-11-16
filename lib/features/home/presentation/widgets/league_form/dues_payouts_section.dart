import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DuesPayoutsSection extends StatefulWidget {
  final double entryFee;
  final List<Map<String, dynamic>> payoutStructure;
  final ValueChanged<double> onEntryFeeChanged;
  final ValueChanged<List<Map<String, dynamic>>> onPayoutStructureChanged;
  final int totalRosters;
  final bool initiallyExpanded;

  const DuesPayoutsSection({
    super.key,
    required this.entryFee,
    required this.payoutStructure,
    required this.onEntryFeeChanged,
    required this.onPayoutStructureChanged,
    required this.totalRosters,
    this.initiallyExpanded = false,
  });

  @override
  State<DuesPayoutsSection> createState() => _DuesPayoutsSectionState();
}

class _DuesPayoutsSectionState extends State<DuesPayoutsSection> {
  late TextEditingController _entryFeeController;
  late List<String> _addedCategories;
  late Map<String, bool> _enabledCategories;
  late Map<String, Map<int, Map<String, dynamic>>> _categoryPayouts;
  late Map<String, List<int>> _visiblePlaces;

  @override
  void initState() {
    super.initState();
    _entryFeeController = TextEditingController(
      text: widget.entryFee > 0 ? widget.entryFee.toStringAsFixed(2) : '',
    );

    _addedCategories = [];
    _enabledCategories = {
      'placement': false,
      'placement_points': false,
      'highest_weekly_score': false,
      'regular_season_winner': false,
      'highest_points_non_playoff': false,
    };
    _categoryPayouts = {
      'placement': {},
      'placement_points': {},
      'highest_weekly_score': {},
      'regular_season_winner': {},
      'highest_points_non_playoff': {},
    };
    _visiblePlaces = {
      'placement': [],
      'placement_points': [],
      'highest_weekly_score': [],
      'regular_season_winner': [],
      'highest_points_non_playoff': [],
    };

    // Load existing payouts
    _loadExistingPayouts();
  }

  void _loadExistingPayouts() {
    final totalPot = widget.entryFee * widget.totalRosters;
    for (var payout in widget.payoutStructure) {
      final type = payout['type'] as String;
      final place = payout['place'] as int? ?? 1;
      final percentage = (payout['percentage'] as num?)?.toDouble() ?? 0.0;
      final amount = (payout['amount'] as num?)?.toDouble() ??
          (percentage > 0 ? totalPot * percentage / 100 : 0.0);

      _enabledCategories[type] = true;
      if (!_addedCategories.contains(type)) {
        _addedCategories.add(type);
      }

      _categoryPayouts[type]![place] = {
        'percentage': percentage,
        'amount': amount,
      };
      if (!_visiblePlaces[type]!.contains(place)) {
        _visiblePlaces[type]!.add(place);
      }
    }

    _visiblePlaces.forEach((key, value) {
      value.sort();
    });
  }

  @override
  void dispose() {
    _entryFeeController.dispose();
    super.dispose();
  }

  void _notifyPayoutChange() {
    final payouts = <Map<String, dynamic>>[];
    _enabledCategories.forEach((type, enabled) {
      if (enabled) {
        _categoryPayouts[type]!.forEach((place, payout) {
          final percentage = (payout['percentage'] as num?)?.toDouble() ?? 0.0;
          if (percentage > 0) {
            payouts.add({
              'type': type,
              'place': place,
              'percentage': percentage,
              'amount': payout['amount'],
            });
          }
        });
      }
    });
    widget.onPayoutStructureChanged(payouts);
  }

  double _calculateTotalAllocatedPercentage() {
    double total = 0.0;
    _enabledCategories.forEach((type, enabled) {
      if (enabled) {
        _categoryPayouts[type]!.forEach((place, payout) {
          total += (payout['percentage'] as num?)?.toDouble() ?? 0.0;
        });
      }
    });
    return total;
  }

  String _getCategoryTitle(String type) {
    switch (type) {
      case 'placement':
        return 'Playoff Finish';
      case 'placement_points':
        return 'Points Ranking';
      case 'highest_weekly_score':
        return 'Highest Week Score';
      case 'regular_season_winner':
        return 'Regular Season Finish';
      case 'highest_points_non_playoff':
        return 'Highest Points (Non-Playoff)';
      default:
        return 'Payout';
    }
  }

  String _getOrdinal(int place) {
    if (place == 1) return '1st';
    if (place == 2) return '2nd';
    if (place == 3) return '3rd';
    return '${place}th';
  }

  Widget _buildAllocationIndicator() {
    final entryFee = double.tryParse(_entryFeeController.text) ?? 0.0;
    if (entryFee <= 0) return const SizedBox.shrink();

    final totalPot = entryFee * widget.totalRosters;
    final totalAllocatedPct = _calculateTotalAllocatedPercentage();
    final remainingPct = 100.0 - totalAllocatedPct;
    final remainingAmount = totalPot * remainingPct / 100;

    Color color;
    String message;
    IconData icon;

    if (remainingPct > 0.01) {
      color = Colors.orange;
      message = 'Remaining: ${remainingPct.toStringAsFixed(1)}% (\$${remainingAmount.toStringAsFixed(2)})';
      icon = Icons.warning_amber;
    } else if (remainingPct < -0.01) {
      color = Colors.red;
      message = 'Over-allocated: ${remainingPct.abs().toStringAsFixed(1)}% (\$${remainingAmount.abs().toStringAsFixed(2)})';
      icon = Icons.error;
    } else {
      color = Colors.green;
      message = 'Fully Allocated ✓';
      icon = Icons.check_circle;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayoutRow({
    required String label,
    required Map<String, dynamic> payout,
    VoidCallback? onRemove,
  }) {
    final entryFee = double.tryParse(_entryFeeController.text) ?? 0.0;
    final totalPot = entryFee * widget.totalRosters;

    // Create controllers if they don't exist
    if (!payout.containsKey('_pctController')) {
      final percentage = (payout['percentage'] as num?)?.toDouble() ?? 0.0;
      payout['_pctController'] = TextEditingController(
        text: percentage > 0 ? percentage.toStringAsFixed(1) : '',
      );
    }
    if (!payout.containsKey('_amtController')) {
      final amount = (payout['amount'] as num?)?.toDouble() ?? 0.0;
      payout['_amtController'] = TextEditingController(
        text: amount > 0 ? amount.toStringAsFixed(2) : '',
      );
    }

    final pctController = payout['_pctController'] as TextEditingController;
    final amtController = payout['_amtController'] as TextEditingController;

    return Row(
      children: [
        if (label.isNotEmpty) ...[
          SizedBox(
            width: 40,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: TextField(
            controller: pctController,
            decoration: const InputDecoration(
              labelText: 'Percentage',
              border: OutlineInputBorder(),
              suffixText: '%',
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            ),
            style: const TextStyle(fontSize: 12),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
            ],
            onChanged: (value) {
              final newPercentage = double.tryParse(value) ?? 0.0;
              payout['percentage'] = newPercentage;
              final newAmount = totalPot * newPercentage / 100;
              payout['amount'] = newAmount;
              amtController.text = newAmount > 0 ? newAmount.toStringAsFixed(2) : '';
              _notifyPayoutChange();
              setState(() {});
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: amtController,
            decoration: const InputDecoration(
              labelText: 'Dollar Amount',
              border: OutlineInputBorder(),
              prefixText: '\$',
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            ),
            style: const TextStyle(fontSize: 12),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            onChanged: (value) {
              final newAmount = double.tryParse(value) ?? 0.0;
              payout['amount'] = newAmount;
              final newPercentage = totalPot > 0 ? (newAmount / totalPot * 100) : 0.0;
              payout['percentage'] = newPercentage;
              pctController.text = newPercentage > 0 ? newPercentage.toStringAsFixed(1) : '';
              _notifyPayoutChange();
              setState(() {});
            },
          ),
        ),
        if (onRemove != null) ...[
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, size: 18),
            color: Colors.red,
            onPressed: onRemove,
            tooltip: 'Remove',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ],
    );
  }

  Widget _buildCategorySection(String type) {
    final title = _getCategoryTitle(type);
    final enabled = _enabledCategories[type]!;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _enabledCategories[type] = !enabled;
                        if (!enabled && _visiblePlaces[type]!.isEmpty) {
                          _visiblePlaces[type]!.add(1);
                          _categoryPayouts[type]![1] = {
                            'percentage': 0.0,
                            'amount': 0.0,
                          };
                        }
                        _notifyPayoutChange();
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          enabled ? Icons.expand_more : Icons.chevron_right,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  color: Colors.red,
                  onPressed: () {
                    setState(() {
                      _addedCategories.remove(type);
                      _enabledCategories[type] = false;
                      _visiblePlaces[type]!.clear();
                      _categoryPayouts[type]!.clear();
                      _notifyPayoutChange();
                    });
                  },
                  tooltip: 'Remove Category',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            if (enabled) ...[
              const SizedBox(height: 8),
              ..._visiblePlaces[type]!.map((place) {
                if (!_categoryPayouts[type]!.containsKey(place)) {
                  _categoryPayouts[type]![place] = {'percentage': 0.0, 'amount': 0.0};
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildPayoutRow(
                    label: _getOrdinal(place),
                    payout: _categoryPayouts[type]![place]!,
                    onRemove: () {
                      setState(() {
                        _visiblePlaces[type]!.remove(place);
                        _categoryPayouts[type]!.remove(place);
                        _notifyPayoutChange();
                      });
                    },
                  ),
                );
              }),
              if (_visiblePlaces[type]!.length < widget.totalRosters)
                Center(
                  child: IconButton(
                    icon: const Icon(Icons.add_circle_outline, size: 24),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      setState(() {
                        final nextPlace = _visiblePlaces[type]!.length + 1;
                        _visiblePlaces[type]!.add(nextPlace);
                        _categoryPayouts[type]![nextPlace] = {
                          'percentage': 0.0,
                          'amount': 0.0,
                        };
                        _notifyPayoutChange();
                      });
                    },
                    tooltip: 'Add ${_getOrdinal(_visiblePlaces[type]!.length + 1)} Place',
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entryFee = double.tryParse(_entryFeeController.text) ?? 0.0;
    final totalPot = entryFee * widget.totalRosters;

    return Card(
      child: ExpansionTile(
        initiallyExpanded: widget.initiallyExpanded,
        title: const Text(
          'Dues / Payouts',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Entry Fee
                TextField(
                  controller: _entryFeeController,
                  decoration: const InputDecoration(
                    labelText: 'Buy-in Amount',
                    border: OutlineInputBorder(),
                    prefixText: '\$',
                    helperText: 'Leave as \$0.00 for free leagues',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  onChanged: (value) {
                    final newFee = double.tryParse(value) ?? 0.0;
                    widget.onEntryFeeChanged(newFee);
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16),
                // Total Pot
                Text(
                  'Total Pot: \$${totalPot.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                // Allocation Indicator
                _buildAllocationIndicator(),
                const SizedBox(height: 24),
                // Payouts Header
                const Text(
                  'Payouts',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                // Added categories
                ..._addedCategories.map(_buildCategorySection),
                // Add category button
                const SizedBox(height: 8),
                Center(
                  child: PopupMenuButton<String>(
                    onSelected: (type) {
                      setState(() {
                        _addedCategories.add(type);
                        _enabledCategories[type] = true;
                        _visiblePlaces[type]!.add(1);
                        _categoryPayouts[type]![1] = {
                          'percentage': 0.0,
                          'amount': 0.0,
                        };
                        _notifyPayoutChange();
                      });
                    },
                    itemBuilder: (context) {
                      final available = {
                        'placement': 'Playoff Finish',
                        'placement_points': 'Points Ranking',
                        'highest_weekly_score': 'Highest Week Score',
                        'regular_season_winner': 'Regular Season Finish',
                        'highest_points_non_playoff': 'Highest Points (Non-Playoff)',
                      }.entries.where((e) => !_addedCategories.contains(e.key)).toList();

                      if (available.isEmpty) {
                        return [
                          const PopupMenuItem<String>(
                            enabled: false,
                            child: Text('All categories added'),
                          ),
                        ];
                      }

                      return available
                          .map((e) => PopupMenuItem<String>(
                                value: e.key,
                                child: Text(e.value),
                              ))
                          .toList();
                    },
                    child: TextButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.add_circle_outline, size: 20),
                      label: const Text('Add Payout Category'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
