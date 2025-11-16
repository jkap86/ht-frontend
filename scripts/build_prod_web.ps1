Write-Host "🏗️ Building PROD Web..."

flutter build web `
  --dart-define=ENV=prod `
  --dart-define=API_BASE_URL=https://api.example.com

Write-Host "✔ Web build complete: build/web"
