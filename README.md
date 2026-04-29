[![Flutter CI](https://github.com/Hans4yu/flutter-ditonton/actions/workflows/flutter-ci.yml/badge.svg)](https://github.com/Hans4yu/flutter-ditonton/actions/workflows/flutter-ci.yml)

# Ditonton

Ditonton is a Flutter movie and TV series catalog app. The app presents movie and TV content with a Cinematic Dark Streaming UI while preserving clean architecture layers, repository logic, and local watchlist behavior.

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

## Project Checklist

- CI: configured through GitHub Actions
- State management: BLoC
- SSL pinning: configured
- Firebase Analytics: configured
- Firebase Crashlytics: configured
- Test coverage target above 95%: verify with `flutter test --coverage`
