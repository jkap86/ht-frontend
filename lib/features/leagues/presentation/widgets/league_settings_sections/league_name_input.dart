import 'package:flutter/material.dart';

/// League name input widget
class LeagueNameInput extends StatefulWidget {
  final String leagueName;
  final Function(String) onNameChanged;

  const LeagueNameInput({
    super.key,
    required this.leagueName,
    required this.onNameChanged,
  });

  @override
  State<LeagueNameInput> createState() => _LeagueNameInputState();
}

class _LeagueNameInputState extends State<LeagueNameInput> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.leagueName);
  }

  @override
  void didUpdateWidget(covariant LeagueNameInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.leagueName != widget.leagueName) {
      _nameController.text = widget.leagueName;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'League Name',
        border: OutlineInputBorder(),
        helperText: 'Must be at least 3 characters',
      ),
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      onChanged: widget.onNameChanged,
    );
  }
}
