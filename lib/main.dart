import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/app_config.dart';
import 'config/app_router.dart';
import 'config/app_theme.dart';

import 'features/auth/application/auth_notifier.dart';
import 'features/auth/application/auth_state.dart';
import 'shared/application/theme_notifier.dart';

late final AppConfig appConfig;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load config from compile-time environment (ENV, API_BASE_URL, etc.)
  appConfig = loadAppConfig();

  // Initialize SharedPreferences before running the app
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeProvider);

    // Show a splash/loading screen while auth is still resolving.
    if (authState.status == AuthStatus.unknown || authState.isLoading) {
      return MaterialApp(
        title: 'Fantasy Football App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp.router(
      title: 'Fantasy Football App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
