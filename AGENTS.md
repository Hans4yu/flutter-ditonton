# Agent Instructions for Ditonton

This repository is a Flutter movie and TV series catalog app.

Primary goal:
Make Ditonton look polished, stable, production-ready, and suitable for final Flutter submission review.

Current design direction:
Use Cinematic Dark Streaming UI.

Use these files as the main source of project-specific context:
- docs/ai/design-system.md
- docs/ai/asset-generation.md
- docs/ai/submission-rules.md

Tool instructions:
- Use @test-android-apps to validate the Android app after UI, navigation, asset, or interaction changes.
- Use $imagegen from C:\Users\farha\.codex\skills\.system\imagegen\SKILL.md when new visual assets are needed.
- Generated assets must be created specifically for this repository.
- Do not inspect, copy, or reuse assets from directories outside this project.
- Do not use copyrighted visuals, Netflix branding, real movie posters, screenshots, or third-party logos.

Rules:
- Do not remove existing features.
- Do not rewrite architecture without a clear technical reason.
- Do not invent missing APIs, routes, assets, classes, or folders.
- If a file is missing, inspect the project or ask for the exact file.
- Do not use files or assets from outside this repository.
- Do not copy Netflix branding or copyrighted visuals.
- Keep the UI original while using a dark premium streaming mood.
- Preserve existing features.
- Keep business logic out of widgets.
- Use BLoC for state management.
- Keep clean architecture boundaries intact.
- Keep domain independent from Flutter, Firebase, HTTP clients, and local storage.
- Prefer small, reviewable, testable changes.
- Do not delete tests to make validation pass.

When editing UI:
- Prefer reusable widgets.
- Avoid long widget files.
- Avoid duplicated styling.
- Use the shared design system.
- Handle loading, empty, error, and success states.
- Avoid layout overflow on common Android screen sizes.
- Use placeholder assets when poster or backdrop images are missing.
- Keep visual changes consistent with Cinematic Dark Streaming UI.

When editing assets:
- Save app icons under assets/icons/.
- Save image assets under assets/images/.
- Save SSL certificates only under assets/certificates/.
- Register new assets in pubspec.yaml.
- Use meaningful lowercase_with_underscores file names.
- Do not add unused assets.
- Do not commit raw oversized generated files.

When editing tests:
- Do not remove tests to make the build pass.
- Add or update tests when behavior changes.
- Keep tests deterministic.
- Do not depend on real network responses unless the existing project already does so intentionally.

Validation after changes:
- flutter pub get
- dart format .
- flutter analyze
- flutter test --coverage
- flutter build apk --debug

Android validation:
After UI or interaction changes, use @test-android-apps to verify:
- app launches without crash
- Home page appears
- hero banner is visible
- Search page opens
- Watchlist page opens
- movie detail opens
- TV series detail opens if supported
- Add to Watchlist button works if implemented
- no blank screen
- no missing asset error
- no visible layout overflow

Before coding:
- Inspect the current file structure.
- Identify the smallest set of files to change.
- Explain risks if the requested change may affect submission requirements.