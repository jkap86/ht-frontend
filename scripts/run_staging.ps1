Write-Host "🚀 Running STAGING environment..."

flutter run -d chrome `
  --dart-define=APP_CONFIG='{"env":"staging","apiBaseUrl":"https://staging-api.example.com"}'
