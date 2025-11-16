Write-Host "🚀 Running STAGING environment..."

flutter run -d chrome `
  --dart-define=ENV=staging `
  --dart-define=API_BASE_URL=https://staging-api.example.com
