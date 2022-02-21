flutter format . 
dart fix --apply
flutter clean
flutter pub get 
flutter analyze
flutter build web
Remove-Item docs/* -Force -Recurse
Copy-Item -Path build/web/* -Destination docs -Recurse