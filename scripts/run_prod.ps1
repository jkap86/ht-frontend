Write-Host "🚀 Running PROD environment..."

flutter run -d chrome `
  --dart-define=APP_CONFIG='{"env":"prod","apiBaseUrl":"https://api.example.com"}'
