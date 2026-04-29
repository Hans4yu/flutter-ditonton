# Search Feature Rules

Search page uses grid poster layout.

Rules:
- Use a clear search input at the top.
- Display results in a poster grid.
- Use PosterGridItem or another reusable widget.
- Do not use horizontal cards on search unless required by existing project structure.
- Debounce input if the current architecture supports it.
- Do not trigger unnecessary API calls on every rebuild.
- Show empty state before search or when no results are found.
- Show error state when request fails.
- Show loading state during request.
- Keep keyboard and scrolling behavior safe on Android.

BLoC rules:
- Search query changes should be handled by BLoC.
- Do not call repository or datasource from widget.
- Avoid storing UI-only state in domain objects.

Testing:
- Test empty query behavior.
- Test successful search.
- Test empty result.
- Test error result.