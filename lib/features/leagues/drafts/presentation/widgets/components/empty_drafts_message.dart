import 'package:flutter/material.dart';

/// Message displayed when no drafts are configured
class EmptyDraftsMessage extends StatelessWidget {
  const EmptyDraftsMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Text(
          'No drafts configured',
          style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
