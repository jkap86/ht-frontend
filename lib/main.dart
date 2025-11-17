import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/app_config.dart';
import 'config/app_theme.dart';

import 'features/auth/application/auth_notifier.dart';
import 'features/auth/application/auth_state.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/register_screen.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/leagues/presentation/league_details_screen.dart';
import 'features/direct_messages/presentation/dm_screen.dart';

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

/// Router provider so we can plug in auth state and guards.
final routerProvider = Provider<GoRouter>((ref) {
  // Watch auth state so the router rebuilds when login/logout happens
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final authStatus = authState.status;
      final String path = state.matchedLocation;

      final bool goingToLogin = path == '/login';
      final bool goingToRegister = path == '/register';

      // While auth is still resolving (unknown state), don't redirect anywhere.
      // This prevents hot reload from forcing users back to login while
      // we're still checking their authentication status.
      if (authStatus == AuthStatus.unknown) {
        return null; // Stay on current route while loading
      }

      final bool isLoggedIn = authStatus == AuthStatus.authenticated;

      // If NOT logged in and trying to access anything except login/register,
      // send to /login.
      if (!isLoggedIn && !(goingToLogin || goingToRegister)) {
        return '/login';
      }

      // If logged in and trying to go to login/register, send to /home instead.
      if (isLoggedIn && (goingToLogin || goingToRegister)) {
        return '/home';
      }

      // No redirect needed.
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/league/:leagueId',
        name: 'league',
        builder: (context, state) {
          final leagueId = int.parse(state.pathParameters['leagueId']!);
          return LeagueDetailsScreen(leagueId: leagueId);
        },
      ),
      GoRoute(
        path: '/messages',
        name: 'messages',
        builder: (context, state) => const DmScreen(),
      ),
    ],
  );
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final router = ref.watch(routerProvider);

    // Show a splash/loading screen while auth is still resolving.
    if (authState.status == AuthStatus.unknown || authState.isLoading) {
      return MaterialApp(
        title: 'Fantasy Football App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
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
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
