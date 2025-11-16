Write-Host "🏗️ Building PROD Android APK..."

flutter build apk --release `
  --dart-define=ENV=prod `
  --dart-define=API_BASE_URL=https://api.example.com

Write-Host "✔ APK build complete: build/app/outputs/flutter-apk/app-release.apk"
