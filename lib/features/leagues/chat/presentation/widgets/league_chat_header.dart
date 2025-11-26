import 'package:flutter/material.dart';

/// Header for league chat with league/DMs tab toggle
class LeagueChatHeader extends StatelessWidget {
  final String leagueName;
  final bool isLeagueSelected;
  final VoidCallback onLeagueSelected;
  final VoidCallback onDmsSelected;

  const LeagueChatHeader({
    super.key,
    required this.leagueName,
    required this.isLeagueSelected,
    required this.onLeagueSelected,
    required this.onDmsSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ChatToggleButton(
                label: leagueName,
                icon: Icons.groups,
                isSelected: isLeagueSelected,
                onTap: onLeagueSelected,
                isLeft: true,
              ),
              _ChatToggleButton(
                label: 'DMs',
                icon: Icons.person,
                isSelected: !isLeagueSelected,
                onTap: onDmsSelected,
                isLeft: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatToggleButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isLeft;

  const _ChatToggleButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.horizontal(
        left: isLeft ? const Radius.circular(8) : Radius.zero,
        right: !isLeft ? const Radius.circular(8) : Radius.zero,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.horizontal(
            left: isLeft ? const Radius.circular(8) : Radius.zero,
            right: !isLeft ? const Radius.circular(8) : Radius.zero,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.textTheme.bodyMedium?.color,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
