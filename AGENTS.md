# Agent Instructions for Ditonton

This repository is a Flutter app named Ditonton.

Use these files as the main source of project-specific context:
- docs/ai/design-system.md
- docs/ai/asset-generation.md
- docs/ai/submission-rules.md

Rules:
- Do not use files or assets from outside this repository.
- Do not copy Netflix branding or copyrighted visuals.
- Keep the UI original while using a dark premium streaming mood.
- Preserve existing features.
- Keep business logic out of widgets.
- Use BLoC for state management.
- Keep clean architecture boundaries intact.
- Run validation after changes:
  - flutter pub get
  - dart format .
  - flutter analyze
  - flutter test --coverage
  - flutter build apk --debug

When editing UI:
- Prefer reusable widgets.
- Avoid long widget files.
- Avoid duplicated styling.
- Use the shared design system.
- Handle loading, error, empty, and success states.

When editing tests:
- Do not remove tests to make the build pass.
- Add or update tests when behavior changes.