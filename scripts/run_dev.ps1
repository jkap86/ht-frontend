Write-Host "🚀 Running DEV environment..."

flutter run -d chrome `
  --dart-define=APP_CONFIG="{\"env\":\"dev\",\"apiBaseUrl\":\"http://localhost:5000\"}"
