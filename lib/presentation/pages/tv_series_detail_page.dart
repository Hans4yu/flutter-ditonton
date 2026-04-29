import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/presentation/provider/tv_series_detail_notifier.dart';
import 'package:ditonton/presentation/widgets/cinematic_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TvSeriesDetailPage extends StatefulWidget {
  const TvSeriesDetailPage({required this.id, super.key});

  static const ROUTE_NAME = '/detail-tv-series';

  final int id;

  @override
  State<TvSeriesDetailPage> createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Provider.of<TvSeriesDetailNotifier>(context, listen: false)
          .fetchTvSeriesDetail(widget.id);
      Provider.of<TvSeriesDetailNotifier>(context, listen: false)
          .loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TvSeriesDetailNotifier>(
        builder: (context, provider, child) {
          if (provider.tvSeriesState == RequestState.Loading) {
            return const LoadingView();
          }
          if (provider.tvSeriesState == RequestState.Loaded) {
            return TvSeriesDetailContent(
              provider.tvSeries,
              provider.tvSeriesRecommendations,
              provider.isAddedToWatchlist,
            );
          }
          return ErrorStateView(message: provider.message);
        },
      ),
    );
  }
}

class TvSeriesDetailContent extends StatelessWidget {
  const TvSeriesDetailContent(
    this.tvSeries,
    this.recommendations,
    this.isAddedWatchlist, {
    super.key,
  });

  final TvSeriesDetail tvSeries;
  final List<TvSeries> recommendations;
  final bool isAddedWatchlist;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _TvDetailHeader(tvSeries: tvSeries),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 16),
                PrimaryWatchlistButton(
                  isAdded: isAddedWatchlist,
                  onPressed: () => _toggleWatchlist(context),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    RatingBadge(rating: tvSeries.voteAverage),
                    _InfoChip(
                        label: _showEpisodeRuntime(tvSeries.episodeRunTime)),
                    _InfoChip(label: tvSeries.status),
                    _InfoChip(
                      label:
                          '${tvSeries.numberOfSeasons} seasons • ${tvSeries.numberOfEpisodes} episodes',
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(_showGenres(tvSeries.genres), style: kSubtitle),
                const SizedBox(height: 6),
                Text('First Air Date: ${tvSeries.firstAirDate}',
                    style: kBodyText),
                const SizedBox(height: 22),
                Text('Overview', style: kHeading6),
                const SizedBox(height: 8),
                Text(tvSeries.overview, style: kBodyText),
                const SizedBox(height: 24),
                Text('Seasons & Episodes', style: kHeading6),
                const SizedBox(height: 10),
                ...tvSeries.seasons
                    .map((season) => _SeasonCard(season: season)),
                const SizedBox(height: 20),
                Text('Recommendations', style: kHeading6),
                const SizedBox(height: 12),
                Consumer<TvSeriesDetailNotifier>(
                  builder: (context, data, child) {
                    if (data.recommendationState == RequestState.Loading) {
                      return const LoadingView(height: 150);
                    }
                    if (data.recommendationState == RequestState.Error) {
                      return ErrorStateView(
                        message: data.message,
                        height: 150,
                      );
                    }
                    if (data.recommendationState == RequestState.Loaded) {
                      return _RecommendationTvSeries(tvSeries: recommendations);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _toggleWatchlist(BuildContext context) async {
    final notifier = Provider.of<TvSeriesDetailNotifier>(
      context,
      listen: false,
    );

    if (!isAddedWatchlist) {
      await notifier.addWatchlist(tvSeries);
    } else {
      await notifier.removeFromWatchlist(tvSeries);
    }

    final message = notifier.watchlistMessage;
    if (!context.mounted) return;

    if (message == TvSeriesDetailNotifier.watchlistAddSuccessMessage ||
        message == TvSeriesDetailNotifier.watchlistRemoveSuccessMessage) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } else {
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(content: Text(message)),
      );
    }
  }

  String _showGenres(List<Genre> genres) {
    return genres.map((genre) => genre.name).join(', ');
  }

  String _showEpisodeRuntime(List<int> episodeRunTime) {
    if (episodeRunTime.isEmpty) return 'Runtime unavailable';
    final runtime = episodeRunTime.first;
    return '${runtime}m / episode';
  }
}

class _TvDetailHeader extends StatelessWidget {
  const _TvDetailHeader({required this.tvSeries});

  final TvSeriesDetail tvSeries;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 390,
      child: Stack(
        children: [
          SizedBox(
            height: 280,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                BackdropImageView(backdropPath: tvSeries.backdropPath),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        kRichBlack.withValues(alpha: 0.28),
                        kRichBlack,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: kRichBlack.withValues(alpha: 0.74),
                foregroundColor: kTextPrimary,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                PosterImageView(
                  posterPath: tvSeries.posterPath,
                  width: 116,
                  height: 174,
                  borderRadius: 8,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      tvSeries.name,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: kHeading5.copyWith(fontSize: 28),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: kSurfaceCard,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: kBorderSubtle),
      ),
      child: Text(
        label,
        style: kBodyText.copyWith(color: kTextPrimary),
      ),
    );
  }
}

class _SeasonCard extends StatelessWidget {
  const _SeasonCard({required this.season});

  final Season season;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kSurfaceCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kBorderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(season.name, style: kHeading6.copyWith(fontSize: 16)),
          const SizedBox(height: 4),
          Text('Season ${season.seasonNumber}', style: kBodyText),
          Text('${season.episodeCount} episodes', style: kBodyText),
          if ((season.airDate ?? '').isNotEmpty)
            Text('Air Date: ${season.airDate}', style: kBodyText),
          if (season.overview.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              season.overview,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: kBodyText,
            ),
          ],
        ],
      ),
    );
  }
}

class _RecommendationTvSeries extends StatelessWidget {
  const _RecommendationTvSeries({required this.tvSeries});

  final List<TvSeries> tvSeries;

  @override
  Widget build(BuildContext context) {
    if (tvSeries.isEmpty) {
      return const SizedBox(
        height: 150,
        child: EmptyStateView(
          title: 'No recommendations',
          message: 'Related TV series are not available yet.',
          assetName: emptySearchAsset,
        ),
      );
    }

    return SizedBox(
      height: 154,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tvSeries.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final recommendation = tvSeries[index];
          return SizedBox(
            width: 96,
            child: InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  TvSeriesDetailPage.ROUTE_NAME,
                  arguments: recommendation.id,
                );
              },
              child: PosterImageView(
                posterPath: recommendation.posterPath,
                width: 96,
                height: 144,
              ),
            ),
          );
        },
      ),
    );
  }
}
