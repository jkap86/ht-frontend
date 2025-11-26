import 'package:flutter/material.dart';
import '../../../domain/league.dart';
import 'info_row.dart';

/// Editable basic info section
class EditableBasicInfoSection extends StatefulWidget {
  final League league;
  final Function(int) onTotalRostersChanged;
  final Function(bool) onIsPublicChanged;
  final Function(String, dynamic) onSettingChanged;
  final bool? initiallyExpanded;
  final Function(bool)? onExpansionChanged;

  const EditableBasicInfoSection({
    super.key,
    required this.league,
    required this.onTotalRostersChanged,
    required this.onIsPublicChanged,
    required this.onSettingChanged,
    this.initiallyExpanded,
    this.onExpansionChanged,
  });

  @override
  State<EditableBasicInfoSection> createState() => _EditableBasicInfoSectionState();
}

class _EditableBasicInfoSectionState extends State<EditableBasicInfoSection> {
  late TextEditingController _totalRostersController;

  @override
  void initState() {
    super.initState();
    _totalRostersController = TextEditingController(text: widget.league.totalRosters.toString());
  }

  @override
  void didUpdateWidget(covariant EditableBasicInfoSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controllers if the league data changes externally
    if (oldWidget.league.totalRosters != widget.league.totalRosters) {
      _totalRostersController.text = widget.league.totalRosters.toString();
    }
  }

  @override
  void dispose() {
    _totalRostersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: widget.initiallyExpanded ?? true,
        onExpansionChanged: widget.onExpansionChanged,
        title: const Text(
          'Basic Information',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Read-only fields
                InfoRow(
                  label: 'Season',
                  value: widget.league.season,
                ),
                InfoRow(
                  label: 'Season Type',
                  value: _formatSeasonType(widget.league.seasonType),
                ),

                // Editable Total Teams
                const SizedBox(height: 8),
                TextFormField(
                  controller: _totalRostersController,
                  decoration: const InputDecoration(
                    labelText: 'Total Teams *',
                    border: OutlineInputBorder(),
                    helperText: 'Number of teams in the league (2-20)',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final parsed = int.tryParse(value);
                    if (parsed != null) {
                      widget.onTotalRostersChanged(parsed);
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Editable League Type (Public/Private)
                SwitchListTile(
                  title: const Text('Public League'),
                  subtitle: const Text('Allow anyone to join'),
                  value: widget.league.settings?['is_public'] == true,
                  onChanged: widget.onIsPublicChanged,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatSeasonType(String seasonType) {
    switch (seasonType.toLowerCase()) {
      case 'regular':
        return 'Regular Season';
      case 'playoff':
        return 'Playoff';
      case 'dynasty':
        return 'Dynasty';
      default:
        return seasonType;
    }
  }
}
