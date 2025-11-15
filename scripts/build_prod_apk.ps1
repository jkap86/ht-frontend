Write-Host "🏗️ Building PROD Android APK..."

flutter build apk --release `
  --dart-define=APP_CONFIG='{"env":"prod","apiBaseUrl":"https://api.example.com"}'

Write-Host "✔ APK build complete: build/app/outputs/flutter-apk/app-release.apk"
