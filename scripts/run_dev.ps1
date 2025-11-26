Write-Host "🚀 Running DEV environment..."

flutter run -d chrome `
  --dart-define=ENV=dev `
  --dart-define=API_BASE_URL=http://localhost:5000
