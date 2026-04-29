# Movie Feature Rules

This feature handles movie list, movie detail, recommendations, and movie watchlist behavior.

Architecture:
- data: models, datasources, repository implementation.
- domain: entities, repository contract, usecases.
- presentation: pages, widgets, BLoC.

Rules:
- Do not mix TV series logic into movie-specific files unless the project already has shared abstractions.
- Do not make movie entity depend on JSON annotations unless it is intentionally a data model.
- Keep mapping from model to entity explicit.
- Keep repository contract in domain.
- Keep API and database implementation in data.

Detail page:
- Use large backdrop at top.
- Poster appears under or slightly overlapping backdrop.
- Show title, rating, genres, duration if available, and overview.
- Use large Add to Watchlist button.
- Recommendations appear below detail content.
- Handle missing poster and backdrop with placeholders.

Testing:
- Add or maintain tests for:
  - usecases
  - repository
  - datasource
  - BLoC
  - important widgets when feasible