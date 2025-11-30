import 'package:flutter/material.dart';

/// Section for selecting users to add to league
class UserSelectionSection extends StatelessWidget {
  final List<String> testUsers;
  final Set<String> selectedUsers;
  final Function(String) onUserToggled;
  final VoidCallback onSelectAll;
  final bool isLoading;
  final VoidCallback onAddSelected;

  const UserSelectionSection({
    super.key,
    required this.testUsers,
    required this.selectedUsers,
    required this.onUserToggled,
    required this.onSelectAll,
    required this.isLoading,
    required this.onAddSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Add Users to League',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            TextButton(
              onPressed: onSelectAll,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white70,
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
              child: Text(
                selectedUsers.length == testUsers.length
                    ? 'Deselect All'
                    : 'Select All',
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...testUsers.map((username) => InkWell(
              onTap: () => onUserToggled(username),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: selectedUsers.contains(username),
                        onChanged: (bool? value) => onUserToggled(username),
                        fillColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.white;
                          }
                          return Colors.white24;
                        }),
                        checkColor: Colors.red.shade900,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: isLoading ? null : onAddSelected,
          icon: const Icon(Icons.group_add, size: 16),
          label: Text(
            'Add Selected (${selectedUsers.length})',
            style: const TextStyle(fontSize: 12),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
          ),
        ),
      ],
    );
  }
}
