# TV Series Feature Rules

This feature handles TV series list, detail, watchlist behavior, season, and episode if available.

Architecture:
- Keep TV series separate from movie when behavior or data differs.
- Share only generic widgets or utilities.
- Do not force movie models to represent TV data.
- Do not duplicate large movie code when a shared abstraction is safer.

Detail page:
- Use large backdrop at top.
- Poster appears under or slightly overlapping backdrop.
- Show title, rating, genres, and overview.
- Show season list if the data exists.
- Show episode list if implemented.
- Use large Add to Watchlist button if TV watchlist is supported.

Rules:
- Handle null or missing season/episode data safely.
- Do not crash when poster, backdrop, overview, or rating is missing.
- Keep state management in BLoC.
- Do not call API directly from widgets.

Testing:
- Add or maintain tests for TV usecases, repository, datasource, BLoC, and key UI states.