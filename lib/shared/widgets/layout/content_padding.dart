import 'package:flutter/material.dart';

/// Standard padding wrapper for consistent spacing.
///
/// This component provides predefined padding values that match
/// the app's design system for consistent spacing throughout.
///
/// Example:
/// ```dart
/// ContentPadding(
///   child: Text('Padded content'),
/// )
/// ```
class ContentPadding extends StatelessWidget {
  /// The widget to wrap with padding
  final Widget child;

  /// The padding type to use
  final PaddingType type;

  const ContentPadding({
    super.key,
    required this.child,
    this.type = PaddingType.standard,
  });

  /// Standard padding (20px all around)
  const ContentPadding.standard({
    super.key,
    required this.child,
  }) : type = PaddingType.standard;

  /// Compact padding (16px all around)
  const ContentPadding.compact({
    super.key,
    required this.child,
  }) : type = PaddingType.compact;

  /// Small padding (12px all around)
  const ContentPadding.small({
    super.key,
    required this.child,
  }) : type = PaddingType.small;

  /// Horizontal only padding (20px horizontal)
  const ContentPadding.horizontal({
    super.key,
    required this.child,
  }) : type = PaddingType.horizontal;

  /// Vertical only padding (20px vertical)
  const ContentPadding.vertical({
    super.key,
    required this.child,
  }) : type = PaddingType.vertical;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _getPadding(),
      child: child,
    );
  }

  EdgeInsets _getPadding() {
    switch (type) {
      case PaddingType.standard:
        return const EdgeInsets.all(20);
      case PaddingType.compact:
        return const EdgeInsets.all(16);
      case PaddingType.small:
        return const EdgeInsets.all(12);
      case PaddingType.horizontal:
        return const EdgeInsets.symmetric(horizontal: 20);
      case PaddingType.vertical:
        return const EdgeInsets.symmetric(vertical: 20);
    }
  }
}

/// Types of standard padding
enum PaddingType {
  /// 20px all around
  standard,

  /// 16px all around
  compact,

  /// 12px all around
  small,

  /// 20px horizontal only
  horizontal,

  /// 20px vertical only
  vertical,
}

/// Standard spacing values as constants
class AppSpacing {
  /// Extra small spacing (4px)
  static const double xs = 4;

  /// Small spacing (8px)
  static const double sm = 8;

  /// Medium spacing (12px)
  static const double md = 12;

  /// Large spacing (16px)
  static const double lg = 16;

  /// Extra large spacing (20px)
  static const double xl = 20;

  /// Extra extra large spacing (24px)
  static const double xxl = 24;

  /// Extra extra extra large spacing (32px)
  static const double xxxl = 32;
}
