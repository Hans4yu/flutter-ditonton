import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:flutter/material.dart';

const String posterPlaceholderAsset = 'assets/images/poster_placeholder.png';
const String backdropPlaceholderAsset =
    'assets/images/backdrop_placeholder.png';
const String emptySearchAsset = 'assets/images/empty_search.png';
const String emptyWatchlistAsset = 'assets/images/empty_watchlist.png';
const String errorStateAsset = 'assets/images/error_state.png';
const String loadingSpriteAsset = 'assets/images/loading_sprite.gif';

class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.title, this.onSeeAll, super.key});

  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: kHeading6,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onSeeAll != null)
            TextButton.icon(
              onPressed: onSeeAll,
              icon: const Icon(Icons.chevron_right, size: 18),
              label: const Text('See all'),
              style: TextButton.styleFrom(
                foregroundColor: kTextSecondary,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
        ],
      ),
    );
  }
}

class RatingBadge extends StatelessWidget {
  const RatingBadge({required this.rating, this.compact = false, super.key});

  final double? rating;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final value = rating ?? 0;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: kSurfaceCard.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: kBorderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 16, color: kMikadoYellow),
          const SizedBox(width: 4),
          Text(
            value.toStringAsFixed(1),
            style: kBodyText.copyWith(
              color: kTextPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class PosterImageView extends StatelessWidget {
  const PosterImageView({
    required this.posterPath,
    this.width,
    this.height,
    this.borderRadius = 8,
    super.key,
  });

  final String? posterPath;
  final double? width;
  final double? height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: _NetworkOrAssetImage(
        imagePath: posterPath,
        baseUrl: BASE_IMAGE_URL,
        fallbackAsset: posterPlaceholderAsset,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}

class BackdropImageView extends StatelessWidget {
  const BackdropImageView({
    required this.backdropPath,
    this.width,
    this.height,
    this.borderRadius = 0,
    super.key,
  });

  final String? backdropPath;
  final double? width;
  final double? height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: _NetworkOrAssetImage(
        imagePath: backdropPath,
        baseUrl: BASE_BACKDROP_URL,
        fallbackAsset: backdropPlaceholderAsset,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({this.height = 160, super.key});

  final double height;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: kRichBlack),
      child: SizedBox(
        height: height,
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CinematicLoadingSprite(),
              SizedBox(height: 12),
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  color: kAccentRed,
                  strokeWidth: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CinematicLoadingSprite extends StatelessWidget {
  const CinematicLoadingSprite({this.size = 56, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: size,
        height: size,
        child: Image.asset(
          loadingSpriteAsset,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}

class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    required this.title,
    required this.message,
    required this.assetName,
    super.key,
  });

  final String title;
  final String message;
  final String assetName;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height =
            constraints.hasBoundedHeight ? constraints.maxHeight : 0.0;
        final isKeyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;
        final isCompact = isKeyboardVisible || (height > 0 && height < 420);
        final isTight = height > 0 && height < 520;
        final imageSize = isTight ? 96.0 : 148.0;
        final padding = isCompact
            ? 12.0
            : isTight
                ? 16.0
                : 24.0;

        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: height),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isCompact) ...[
                      Image.asset(
                        assetName,
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: isTight ? 12 : 20),
                    ],
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: isTight ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: kHeading6,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      maxLines: isTight ? 2 : 4,
                      overflow: TextOverflow.ellipsis,
                      style: kBodyText,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ErrorStateView extends StatelessWidget {
  const ErrorStateView({required this.message, this.height, super.key});

  final String message;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final content = EmptyStateView(
      title: 'Content is unavailable',
      message: message.isEmpty
          ? 'We could not load this section. Please try again later.'
          : message,
      assetName: errorStateAsset,
    );

    if (height == null) return content;
    return SizedBox(height: height, child: content);
  }
}

class PrimaryWatchlistButton extends StatelessWidget {
  const PrimaryWatchlistButton({
    required this.isAdded,
    required this.onPressed,
    super.key,
  });

  final bool isAdded;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(isAdded ? Icons.check : Icons.add),
        label: Text(isAdded ? 'Added to Watchlist' : 'Add to Watchlist'),
      ),
    );
  }
}

class PosterGridItem extends StatelessWidget {
  const PosterGridItem({
    required this.title,
    required this.posterPath,
    required this.onTap,
    this.rating,
    super.key,
  });

  final String title;
  final String? posterPath;
  final double? rating;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: PosterImageView(
                    posterPath: posterPath,
                    borderRadius: 8,
                  ),
                ),
                Positioned(
                  left: 8,
                  top: 8,
                  child: RatingBadge(rating: rating, compact: true),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: kBodyText.copyWith(
              color: kTextPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _NetworkOrAssetImage extends StatelessWidget {
  const _NetworkOrAssetImage({
    required this.imagePath,
    required this.baseUrl,
    required this.fallbackAsset,
    required this.fit,
    this.width,
    this.height,
  });

  final String? imagePath;
  final String baseUrl;
  final String fallbackAsset;
  final BoxFit fit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    if (imagePath == null || imagePath!.isEmpty) {
      return Image.asset(fallbackAsset, width: width, height: height, fit: fit);
    }

    return CachedNetworkImage(
      imageUrl: '$baseUrl$imagePath',
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        color: kSurfaceCard,
        child: const Center(
          child: CircularProgressIndicator(color: kAccentRed),
        ),
      ),
      errorWidget: (context, url, error) =>
          Image.asset(fallbackAsset, width: width, height: height, fit: fit),
    );
  }
}
