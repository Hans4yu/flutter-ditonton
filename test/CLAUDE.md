# Test Rules

This folder contains unit, widget, and BLoC tests.

Rules:
- Do not delete tests just to make the suite pass.
- Do not reduce expectations to meaningless checks.
- Keep tests deterministic.
- Mock network and database dependencies.
- Do not call real API in tests.
- Use fixtures for JSON responses.
- Keep fixtures valid and minimal.
- Update tests when behavior changes.

Coverage target:
- Aim for more than 95% coverage.
- Do not fake coverage.
- If coverage is low, identify uncovered files and add meaningful tests.

Test categories:
- Unit tests for usecases.
- Unit tests for repositories.
- Unit tests for datasources.
- BLoC tests for events and state transitions.
- Widget tests for important UI states:
  - loading
  - success
  - empty
  - error

Validation:
- Run flutter test --coverage.
- Fix failing tests before claiming work is complete.