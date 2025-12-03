class AppConfig {
  final String env;
  final String apiBaseUrl;

  const AppConfig({
    required this.env,
    required this.apiBaseUrl,
  });
}

AppConfig loadAppConfig() {
  const env = String.fromEnvironment('ENV', defaultValue: 'dev');
  // Use local network IP for Android device testing (localhost won't work on physical devices)
  // Change this IP to match your computer's WiFi IP address
  const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.1.171:5000',
  );

  return AppConfig(env: env, apiBaseUrl: apiBaseUrl);
}
