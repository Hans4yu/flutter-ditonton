# Ditonton Design System

Design concept:
Cinematic Dark Streaming UI.

Goal:
Make Ditonton feel like a polished movie and TV catalog app that is ready for release.

Do not:
- Copy Netflix branding.
- Use Netflix logo, typography, icons, screenshots, or exact layout.
- Add flashy effects that hurt readability.
- Add large UI changes without checking navigation and tests.
- Use random colors outside the defined palette.

Color palette:
- Background primary: #0B0B0F
- Background secondary: #121218
- Surface/card: #1A1A22
- Accent red: #E50914
- Accent pressed: #B20710
- Rating/star: #F5C451
- Text primary: #F5F5F5
- Text secondary: #B9BBC6
- Border subtle: #2A2A35
- Error: #CF6679

Visual tone:
- Dark
- Clean
- Serious
- Professional
- Content-focused
- Premium but not overly decorative

Home page:
- Use bottom navigation with:
  - Home
  - Search
  - Watchlist
- Home section order:
  1. Hero Banner
  2. Now Playing
  3. Popular
  4. Top Rated
  5. On The Air TV Series
  6. Popular TV Series
- Hero banner:
  - Movie only
  - Large top banner
  - Auto-slide every 2 seconds
  - Swipe manually
  - Pause briefly after manual interaction, then resume
  - Use gradient overlay for readable text
  - Show title and rating
  - Keep text minimal

Movie and TV cards:
- Use horizontal card style for home and watchlist.
- Poster on the left.
- Title, rating, and genre/metadata on the right.
- Avoid showing long overview in small cards unless space is safe.
- Use placeholder image when poster is unavailable.
- Keep card height consistent.

Search page:
- Use grid poster layout.
- Search input must be clear and easy to access.
- Show professional empty state when there are no results.
- Show error state when search fails.
- Avoid horizontal cards on search page unless the existing layout requires it.

Detail page:
- Use large backdrop at the top.
- Use poster below or slightly overlapping backdrop.
- Show title, rating, genres, duration if available, and overview.
- Use a large Add to Watchlist button.
- Recommendations should use horizontal list.
- Use gradient on backdrop so text remains readable.
- Keep layout safe on small Android screens.

State views:
- Loading state must not look broken.
- Empty state must be serious and professional.
- Error state must clearly explain the failure and provide retry when possible.
- Do not use joke copy or casual empty text.

Reusable widgets:
Prefer creating or reusing:
- HeroBannerCarousel
- SectionHeader
- ContentHorizontalCard
- PosterGridItem
- RatingBadge
- PrimaryWatchlistButton
- PosterImageView
- BackdropImageView
- EmptyStateView
- ErrorStateView
- LoadingView

Spacing:
- Use consistent spacing.
- Avoid magic numbers scattered across widgets.
- Prefer shared constants if the project already has them.
- Do not create a large design token system if the app is small; keep it practical.