# Ditonton Project Instructions

You are working on Ditonton, a Flutter movie and TV series catalog app.

Primary goal:
Make the app look polished, stable, production-ready, and suitable for final Flutter submission review.

Current design direction:
Use Cinematic Dark Streaming UI.

Read these project references before making UI or submission-related changes:
- @docs/ai/design-system.md
- @docs/ai/asset-generation.md
- @docs/ai/submission-rules.md

Main rules:
- Do not remove existing features.
- Do not rewrite architecture without a clear reason.
- Do not move files across layers unless the dependency direction stays correct.
- Do not invent missing APIs, routes, assets, or classes.
- If a file is missing, ask for that file or inspect the project first.
- Keep changes small, reviewable, and testable.
- Prefer reusable widgets over duplicated UI code.
- Keep business logic out of widgets.
- Use BLoC for presentation state management.
- Keep domain layer independent from Flutter, Firebase, HTTP clients, and local storage.
- Follow Effective Dart naming and formatting conventions.
- Always run or request validation after changes:
  - flutter pub get
  - dart format .
  - flutter analyze
  - flutter test --coverage
  - flutter build apk --debug

Design rules:
- Use dark cinematic visuals.
- Do not copy Netflix branding, logo, layout, or protected assets.
- Use the mood only: dark, premium, streaming-style, content-focused.
- Use the app’s own original assets.
- Never use assets from outside this project.
- Do not add decorative UI that creates overflow risk.
- Every loading, empty, error, and success state must be handled.

Before coding:
- Inspect the current file structure.
- Identify the smallest set of files to change.
- Explain risks if the requested change may affect submission requirements.

Tool instructions:
- For Android app validation, use @test-android-apps after UI, navigation, asset, or interaction changes.
- For visual asset generation, use $imagegen from C:\Users\farha\.codex\skills\.system\imagegen\SKILL.md.
- Generated assets must be created specifically for this repository.
- Do not inspect, copy, or reuse assets from directories outside this project.