import 'package:flutter/material.dart';

/// Reusable info section card with expansion tile
class InfoSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool? initiallyExpanded;
  final Function(bool)? onExpansionChanged;

  const InfoSection({
    super.key,
    required this.title,
    required this.children,
    this.initiallyExpanded,
    this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded ?? false,
        onExpansionChanged: onExpansionChanged,
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
