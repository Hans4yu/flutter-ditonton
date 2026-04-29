# Submission Rules

Goal:
Prepare Ditonton for final Flutter submission review.

Mandatory requirements:
- Continuous Integration runs automatically on push.
- All tests pass.
- README shows build status badge.
- GitHub repository is public.
- Screenshot of successful CI build is attached.
- State management is migrated to BLoC.
- SSL pinning is implemented.
- Firebase Analytics is integrated.
- Firebase Crashlytics is integrated.
- Screenshot of Analytics page is attached.
- Screenshot of Crashlytics page is attached.
- App can run without crashing.
- Submission ZIP does not include build folder.

High score targets:
- Modularize movie and TV series features.
- Add season and episode support if feasible.
- Add widget tests.
- Add integration tests.
- Reach test coverage above 95%.
- Keep code clean and consistent.
- Pass flutter analyze.
- Follow Dart conventions.

Do not:
- Remove tests to pass CI.
- Disable failing code without fixing it.
- Fake test coverage.
- Accept all SSL certificates.
- Put secrets in public repository.
- Leave generated junk files in the ZIP.
- Submit private repository link.
- Leave build folder in submission ZIP.
- Add UI that breaks on common Android screen sizes.

Validation commands:
- flutter clean
- flutter pub get
- dart format .
- flutter analyze
- flutter test --coverage
- flutter build apk --debug

Before submission:
- Delete build folder.
- Check README badge.
- Check repository visibility.
- Check CI screenshot.
- Check Firebase screenshots.
- Check app launches on Android.
- Check main flows:
  - Home
  - Movie detail
  - TV series detail
  - Search
  - Watchlist add/remove
  - Empty state
  - Error state