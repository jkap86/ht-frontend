import 'package:flutter/material.dart';

/// Draft order settings section (randomize vs derby)
class EditDraftOrderSettingsSection extends StatelessWidget {
  final String draftOrder;
  final bool isCommissioner;
  final Function(String) onDraftOrderChanged;

  const EditDraftOrderSettingsSection({
    super.key,
    required this.draftOrder,
    required this.isCommissioner,
    required this.onDraftOrderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: draftOrder,
      decoration: const InputDecoration(
          labelText: 'Draft Order', border: OutlineInputBorder()),
      items: const [
        DropdownMenuItem(value: 'randomize', child: Text('Randomize')),
        DropdownMenuItem(value: 'derby', child: Text('Derby')),
      ],
      onChanged: isCommissioner
          ? (value) {
              if (value != null) onDraftOrderChanged(value);
            }
          : null,
    );
  }
}
