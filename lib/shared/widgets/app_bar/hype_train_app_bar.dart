import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/theme_notifier.dart';

/// A reusable app bar component.
class HypeTrainAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HypeTrainAppBar({
    super.key,
    required this.title,
    this.isLoggedIn = false,
    this.onProfileTap,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
  });

  /// The title to display in the app bar.
  final String title;

  /// Whether the user is logged in. Shows profile icon when true.
  final bool isLoggedIn;

  /// Callback when profile icon is tapped.
  final VoidCallback? onProfileTap;

  /// Additional action widgets to display on the right side.
  final List<Widget>? actions;

  /// Optional leading widget (e.g., back button).
  final Widget? leading;

  /// Whether to center the title. Defaults to true.
  final bool centerTitle;

  /// Optional background color override.
  final Color? backgroundColor;

  /// Optional foreground (text/icon) color override.
  final Color? foregroundColor;

  /// Optional elevation override.
  final double? elevation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    final effectiveForeground = foregroundColor ?? theme.colorScheme.onPrimary;

    // Determine leading widget - show back button if we can pop and no custom leading provided
    // Use GoRouter's canPop since the app uses GoRouter for navigation
    final canPop = GoRouter.of(context).canPop();
    final effectiveLeading = leading ??
        (canPop
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: effectiveForeground),
                tooltip: 'Back',
                onPressed: () => context.pop(),
              )
            : null);

    // Build the actions list
    final actionWidgets = <Widget>[
      // Theme toggle - always shown
      IconButton(
        icon: Icon(
          isDark ? Icons.light_mode : Icons.dark_mode,
          color: effectiveForeground,
        ),
        tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
        onPressed: () => themeNotifier.toggleTheme(),
      ),
      // Profile icon - only shown when logged in
      if (isLoggedIn)
        IconButton(
          icon: Icon(
            Icons.account_circle,
            color: effectiveForeground,
          ),
          tooltip: 'Profile',
          onPressed: onProfileTap,
        ),
      // Additional custom actions
      if (actions != null) ...actions!,
    ];

    return AppBar(
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: effectiveForeground,
        ),
      ),
      centerTitle: centerTitle,
      leading: effectiveLeading,
      automaticallyImplyLeading: false,
      actions: actionWidgets,
      backgroundColor: backgroundColor ?? theme.colorScheme.primary,
      foregroundColor: effectiveForeground,
      elevation: elevation ?? 2,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
