import 'package:flutter/material.dart';

/// Collapsible card with an expandable header.
///
/// This component provides a card that can be expanded/collapsed by
/// tapping the header. Useful for organizing related content that can
/// be hidden when not needed.
///
/// Example:
/// ```dart
/// ExpandableCard(
///   header: Text('Click to expand'),
///   child: Text('Expanded content'),
///   isExpanded: true,
///   onToggle: (expanded) => print('Toggled: $expanded'),
/// )
/// ```
class ExpandableCard extends StatefulWidget {
  /// The header widget that is always visible
  final Widget header;

  /// The content to show when expanded
  final Widget child;

  /// Whether the card should be expanded initially
  final bool initiallyExpanded;

  /// Callback when the expansion state changes
  final ValueChanged<bool>? onToggle;

  /// Optional card elevation
  final double? elevation;

  /// Optional background color
  final Color? color;

  /// Optional padding for the header
  final EdgeInsetsGeometry headerPadding;

  /// Optional padding for the content
  final EdgeInsetsGeometry contentPadding;

  /// Whether to show a divider between header and content
  final bool showDivider;

  const ExpandableCard({
    super.key,
    required this.header,
    required this.child,
    this.initiallyExpanded = false,
    this.onToggle,
    this.elevation = 2,
    this.color,
    this.headerPadding = const EdgeInsets.all(16),
    this.contentPadding = const EdgeInsets.all(16),
    this.showDivider = true,
  });

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    widget.onToggle?.call(_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: widget.elevation,
      color: widget.color,
      child: Column(
        children: [
          InkWell(
            onTap: _toggleExpanded,
            child: Padding(
              padding: widget.headerPadding,
              child: Row(
                children: [
                  Expanded(child: widget.header),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            if (widget.showDivider) const Divider(height: 1),
            Padding(
              padding: widget.contentPadding,
              child: widget.child,
            ),
          ],
        ],
      ),
    );
  }
}

/// Section within an expandable card.
///
/// This component is designed to be used within cards that have multiple
/// collapsible sections, like the draft card with draft order and settings.
///
/// Example:
/// ```dart
/// ExpandableSection(
///   title: 'Draft Order',
///   badge: Text('Derby'),
///   isExpanded: true,
///   onToggle: () => setState(() => expanded = !expanded),
///   child: Text('Draft order content'),
/// )
/// ```
class ExpandableSection extends StatelessWidget {
  /// The section title
  final String title;

  /// Optional badge widget to show next to title
  final Widget? badge;

  /// Whether the section is expanded
  final bool isExpanded;

  /// Callback when the section is toggled
  final VoidCallback onToggle;

  /// The content to show when expanded
  final Widget child;

  /// Optional padding for the header
  final EdgeInsetsGeometry headerPadding;

  /// Optional padding for the content
  final EdgeInsetsGeometry contentPadding;

  /// Whether to show a divider before the content
  final bool showDivider;

  const ExpandableSection({
    super.key,
    required this.title,
    this.badge,
    required this.isExpanded,
    required this.onToggle,
    required this.child,
    this.headerPadding = const EdgeInsets.all(16),
    this.contentPadding = const EdgeInsets.all(16),
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onToggle,
          child: Padding(
            padding: headerPadding,
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        badge!,
                      ],
                    ],
                  ),
                ),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) ...[
          if (showDivider) const Divider(height: 1),
          Padding(
            padding: contentPadding,
            child: child,
          ),
        ],
      ],
    );
  }
}
