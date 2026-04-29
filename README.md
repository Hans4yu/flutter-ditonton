[![Flutter CI](https://github.com/Hans4yu/flutter-ditonton/actions/workflows/flutter-ci.yml/badge.svg)](https://github.com/Hans4yu/flutter-ditonton/actions/workflows/flutter-ci.yml)

# Ditonton

Ditonton is a Flutter movie and TV series catalog app built for the Flutter Expert final submission. The app presents movie and TV content with a Cinematic Dark Streaming UI while preserving the existing clean architecture layers, repository logic, and local watchlist behavior.

## Features

- Movie catalog
- TV series catalog
- Search
- Watchlist
- Cinematic Dark Streaming UI

## Development Commands

```bash
flutter pub get
flutter analyze
flutter test --coverage
flutter build apk --debug
```

Use this command before committing to keep formatting consistent with CI:

```bash
dart format --set-exit-if-changed .
```

## Submission Proof Checklist

- CI screenshot: pending
- Analytics screenshot: pending
- Crashlytics screenshot: pending
- Public GitHub repository link in student notes: pending

## Submission Status

- Continuous Integration: configured through GitHub Actions
- BLoC migration: pending
- SSL pinning: pending
- Firebase Analytics: pending
- Firebase Crashlytics: pending
- Test coverage target above 95%: verify with `flutter test --coverage`
- Submission ZIP cleanup: pending, run `flutter clean` before creating the final ZIP and do not include generated build folders
