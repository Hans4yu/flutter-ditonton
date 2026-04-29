# CI Workflow Rules

This folder contains GitHub Actions workflows.

Rules:
- CI must run on push.
- CI should also run on pull_request when possible.
- Do not store secrets directly in workflow files.
- Do not skip tests to make CI green.
- Do not ignore flutter analyze failures unless there is a documented reason.
- README must show build status badge.

Recommended CI steps:
- Checkout repository.
- Set up Flutter stable.
- Run flutter pub get.
- Run dart format check if configured.
- Run flutter analyze.
- Run flutter test --coverage.
- Optionally run flutter build apk --debug.

Submission proof:
- CI screenshot must show a successful build.
- README badge must match the active workflow.