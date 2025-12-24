import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/socket/socket_providers.dart';
import '../../../auth/application/auth_notifier.dart';
import '../../dues_payouts/application/league_members_provider.dart';
import '../../application/leagues_provider.dart';
import 'dev_tools_components/user_selection_section.dart';
import 'dev_tools_components/quick_login_section.dart';
import 'dev_tools_components/status_display.dart';

/// Shows the developer tools dialog - only in debug mode
void showDeveloperToolsDialog(BuildContext context, int leagueId) {
  if (kReleaseMode) return;

  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (context) => DeveloperToolsDialog(leagueId: leagueId),
  );
}

/// Developer tools dialog content
class DeveloperToolsDialog extends ConsumerStatefulWidget {
  final int leagueId;

  const DeveloperToolsDialog({
    super.key,
    required this.leagueId,
  });

  @override
  ConsumerState<DeveloperToolsDialog> createState() =>
      _DeveloperToolsDialogState();
}

class _DeveloperToolsDialogState extends ConsumerState<DeveloperToolsDialog> {
  bool _isLoading = false;
  String? _statusMessage;

  final List<String> _testUsers = List.generate(12, (i) => 'test${i + 1}');
  final Set<String> _selectedUsers = {};

  Future<void> _addSelectedUsersToLeague() async {
    if (_selectedUsers.isEmpty) {
      setState(() {
        _statusMessage = 'No users selected';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    try {
      final repository = ref.read(leaguesRepositoryProvider);
      final results = await repository.devAddUsersToLeague(
        widget.leagueId,
        _selectedUsers.toList(),
      );

      if (!mounted) return;

      final successes = results.where((r) => r['success'] == true).length;
      final failures = results.where((r) => r['success'] == false).length;

      if (successes > 0) {
        ref.invalidate(leagueMembersProvider(widget.leagueId));
      }

      setState(() {
        if (failures == 0) {
          _statusMessage = 'Successfully added $successes user(s) to league';
          _selectedUsers.clear();
        } else {
          _statusMessage = 'Added $successes user(s), $failures failed';
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Error: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _quickLogin(String username) async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    try {
      await ref.read(authProvider.notifier).login(username, 'password');

      if (!mounted) return;

      setState(() {
        _statusMessage = 'Logged in as $username';
      });

      ref.invalidate(socketServiceProvider);

      if (mounted) {
        Navigator.of(context).pop();
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Login failed: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 80, right: 16),
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(8),
          color: Colors.red.shade900,
          child: Container(
            width: 300,
            constraints: const BoxConstraints(maxHeight: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade800,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Developer Tools',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.close, color: Colors.white, size: 18),
                        onPressed: () => Navigator.of(context).pop(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),

                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        UserSelectionSection(
                          testUsers: _testUsers,
                          selectedUsers: _selectedUsers,
                          onUserToggled: (username) {
                            setState(() {
                              if (_selectedUsers.contains(username)) {
                                _selectedUsers.remove(username);
                              } else {
                                _selectedUsers.add(username);
                              }
                            });
                          },
                          onSelectAll: () {
                            setState(() {
                              if (_selectedUsers.length == _testUsers.length) {
                                _selectedUsers.clear();
                              } else {
                                _selectedUsers.addAll(_testUsers);
                              }
                            });
                          },
                          isLoading: _isLoading,
                          onAddSelected: _addSelectedUsersToLeague,
                        ),

                        const SizedBox(height: 12),
                        const Divider(color: Colors.white24),
                        const SizedBox(height: 8),

                        QuickLoginSection(
                          testUsers: _testUsers,
                          isLoading: _isLoading,
                          onLogin: _quickLogin,
                        ),

                        StatusDisplay(
                          statusMessage: _statusMessage,
                          isLoading: _isLoading,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
