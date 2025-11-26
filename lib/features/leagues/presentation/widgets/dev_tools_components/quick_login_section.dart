import 'package:flutter/material.dart';

/// Section for quick login to test accounts
class QuickLoginSection extends StatelessWidget {
  final List<String> testUsers;
  final bool isLoading;
  final Function(String) onLogin;

  const QuickLoginSection({
    super.key,
    required this.testUsers,
    required this.isLoading,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Quick Login',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        ...testUsers.map((username) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: OutlinedButton(
                onPressed: isLoading ? null : () => onLogin(username),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white24),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                ),
                child: Text(
                  username,
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            )),
      ],
    );
  }
}
