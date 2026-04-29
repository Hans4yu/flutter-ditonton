# Home Feature Rules

Home is the main discovery surface.

Required sections:
1. Hero Banner
2. Now Playing
3. Popular
4. Top Rated
5. On The Air TV Series
6. Popular TV Series

Hero banner rules:
- Use movies only.
- Show large banner at top.
- Auto-slide every 2 seconds.
- Allow manual swipe.
- Pause auto-slide briefly after manual swipe, then resume.
- Dispose timers and controllers properly.
- Do not leak timers.
- Use gradient overlay for readability.
- Keep text minimal.

Section rules:
- Use consistent section header.
- Use horizontal lists.
- Use ContentHorizontalCard or similar reusable card.
- Do not duplicate card UI per section.
- Show loading state while fetching.
- Show error state when fetch fails.
- Show empty state only when data is truly empty.

BLoC rules:
- Fetch data through BLoC/usecases.
- Do not call usecases directly from widgets.
- Avoid creating one giant BLoC if existing feature separation is clearer.