# Flutter Source Rules

This folder contains application source code.

General rules:
- Keep widgets focused on UI.
- Keep business logic in BLoC, usecases, repositories, or services.
- Do not put network calls directly inside widgets.
- Do not put database calls directly inside widgets.
- Do not create one large file for multiple responsibilities.
- Prefer small reusable widgets.
- Use const constructors when possible.
- Follow dart format output.
- Follow Effective Dart naming:
  - Classes: UpperCamelCase
  - Methods, variables, parameters: lowerCamelCase
  - Files and folders: lowercase_with_underscores

Architecture rules:
- data layer handles models, datasources, and repository implementations.
- domain layer handles entities, repository contracts, and usecases.
- presentation layer handles pages, widgets, BLoC, events, and states.
- domain must not depend on Flutter, Firebase, HTTP clients, or local database implementation.
- presentation may depend on domain.
- data may implement domain repository contracts.

UI rules:
- Follow docs/ai/design-system.md.
- Handle loading, error, empty, and success states.
- Use placeholders when network images are missing.
- Avoid layout overflow.
- Keep text readable on dark backgrounds.