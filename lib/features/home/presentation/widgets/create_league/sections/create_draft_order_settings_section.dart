import 'package:flutter/material.dart';

/// Draft order settings section for create league flow
class CreateDraftOrderSettingsSection extends StatelessWidget {
  final String draftOrder;
  final Function(String) onDraftOrderChanged;

  const CreateDraftOrderSettingsSection({
    super.key,
    required this.draftOrder,
    required this.onDraftOrderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: draftOrder,
      decoration: const InputDecoration(
          labelText: 'Draft Order', border: OutlineInputBorder()),
      items: const [
        DropdownMenuItem(value: 'random', child: Text('Randomize')),
        DropdownMenuItem(value: 'derby', child: Text('Derby')),
      ],
      onChanged: (value) {
        if (value != null) onDraftOrderChanged(value);
      },
    );
  }
}
