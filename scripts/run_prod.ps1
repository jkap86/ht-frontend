Write-Host "🚀 Running PROD environment..."

flutter run -d chrome `
  --dart-define=ENV=prod `
  --dart-define=API_BASE_URL=https://api.example.com
