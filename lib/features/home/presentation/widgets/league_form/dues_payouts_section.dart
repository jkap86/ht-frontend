import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/components.dart';
import 'utils/payout_helpers.dart';

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
                PayoutAllocationIndicator(
                  entryFee: entryFee,
                  totalRosters: widget.totalRosters,
                  totalAllocatedPercentage: _calculateTotalAllocatedPercentage(),
                ),
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
                ..._addedCategories.map((type) => PayoutCategorySection(
                      type: type,
                      enabled: _enabledCategories[type]!,
                      visiblePlaces: _visiblePlaces[type]!,
                      categoryPayouts: _categoryPayouts[type]!,
                      totalRosters: widget.totalRosters,
                      totalPot: totalPot,
                      onToggleEnabled: () {
                        setState(() {
                          _enabledCategories[type] = !_enabledCategories[type]!;
                          if (_enabledCategories[type]! && _visiblePlaces[type]!.isEmpty) {
                            _visiblePlaces[type]!.add(1);
                            _categoryPayouts[type]![1] = {
                              'percentage': 0.0,
                              'amount': 0.0,
                            };
                          }
                          _notifyPayoutChange();
                        });
                      },
                      onRemoveCategory: () {
                        setState(() {
                          _addedCategories.remove(type);
                          _enabledCategories[type] = false;
                          _visiblePlaces[type]!.clear();
                          _categoryPayouts[type]!.clear();
                          _notifyPayoutChange();
                        });
                      },
                      onAddPlace: (place) {
                        setState(() {
                          _visiblePlaces[type]!.add(place);
                          _categoryPayouts[type]![place] = {
                            'percentage': 0.0,
                            'amount': 0.0,
                          };
                          _notifyPayoutChange();
                        });
                      },
                      onRemovePlace: (place) {
                        setState(() {
                          _visiblePlaces[type]!.remove(place);
                          _categoryPayouts[type]!.remove(place);
                          _notifyPayoutChange();
                        });
                      },
                      onPayoutChanged: () {
                        _notifyPayoutChange();
                        setState(() {});
                      },
                    )),
                // Add category button
                const SizedBox(height: 8),
                PayoutCategorySelector(
                  addedCategories: _addedCategories,
                  onCategorySelected: (type) {
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
