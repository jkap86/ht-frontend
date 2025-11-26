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
  const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:5000',
  );

  return AppConfig(env: env, apiBaseUrl: apiBaseUrl);
}
