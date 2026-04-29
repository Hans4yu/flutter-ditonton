# Shared Widget Rules

This folder contains reusable UI widgets.

Allowed widgets:
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

Rules:
- Widgets must be reusable and not tied to one feature unless necessary.
- Do not call repositories, usecases, datasources, or APIs from shared widgets.
- Do not create BLoC instances inside reusable widgets.
- Receive data through constructor parameters.
- Use callbacks for actions.
- Keep widget files focused.
- Avoid deeply nested build methods.
- Extract private helper widgets when the build method becomes hard to read.

Visual rules:
- Follow Cinematic Dark Streaming UI.
- Maintain consistent spacing.
- Avoid random shadows or gradients.
- Use placeholders for missing images.
- Ensure small Android screens do not overflow.