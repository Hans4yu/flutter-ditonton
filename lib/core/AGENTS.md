# Core Layer Rules

This folder contains shared infrastructure and app-wide utilities.

Allowed responsibilities:
- Theme
- Constants
- Routes
- Network client
- SSL pinning setup
- Error handling
- Exceptions
- Failures
- Usecase base types
- Shared utilities
- Dependency injection helpers

Rules:
- Keep core independent from feature UI.
- Do not place page-specific widgets here.
- Do not place feature-specific business logic here.
- Do not hardcode API behavior in multiple places.
- Keep HTTP client creation centralized.
- SSL pinning must not accept all bad certificates.
- Firebase setup must be centralized and easy to verify.

Design system:
- If theme files exist, keep color and text style definitions here.
- Do not scatter raw color values across feature widgets.
- Use the Cinematic Dark Streaming UI palette from docs/ai/design-system.md.