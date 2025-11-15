Write-Host "🏗️ Building PROD Web..."

flutter build web `
  --dart-define=APP_CONFIG='{"env":"prod","apiBaseUrl":"https://api.example.com"}'

Write-Host "✔ Web build complete: build/web"
