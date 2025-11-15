// lib/config/app_config.dart
import 'dart:convert';

class AppConfig {
  final String env;
  final String apiBaseUrl;

  const AppConfig({
    required this.env,
    required this.apiBaseUrl,
  });

  /// Loads configuration from the APP_CONFIG dart-define.
  ///
  /// Example:
  /// flutter run -d chrome \
  ///   --dart-define=APP_CONFIG='{"env":"dev","apiBaseUrl":"http://localhost:5000"}'
  static AppConfig load() {
    const raw = String.fromEnvironment('APP_CONFIG', defaultValue: '{}');

    Map<String, dynamic> json = {};

    if (raw.isNotEmpty) {
      try {
        json = jsonDecode(raw) as Map<String, dynamic>;
      } catch (e) {
        // If APP_CONFIG is invalid JSON, log it and fall back to defaults
        // ignore: avoid_print
        print('⚠️ Failed to parse APP_CONFIG: "$raw" ($e)');
      }
    }

    return AppConfig(
      env: json['env'] as String? ?? 'dev',
      apiBaseUrl: json['apiBaseUrl'] as String? ?? 'http://localhost:5000',
    );
  }
}

/// Global singleton instance you can import anywhere.
final appConfig = AppConfig.load();
