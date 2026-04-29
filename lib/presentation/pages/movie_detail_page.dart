import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_event.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_state.dart';
import 'package:ditonton/presentation/widgets/cinematic_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailPage extends StatefulWidget {
  MovieDetailPage({required this.id, super.key});

  static const ROUTE_NAME = '/detail';

  final int id;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MovieDetailBloc>()
        ..add(FetchMovieDetail(widget.id))
        ..add(LoadMovieWatchlistStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MovieDetailBloc, MovieDetailState>(
        listenWhen: (previous, current) =>
            previous.watchlistMessage != current.watchlistMessage &&
            current.watchlistMessage.isNotEmpty,
        listener: (context, state) {
          final message = state.watchlistMessage;
          if (message == MovieDetailBloc.watchlistAddSuccessMessage ||
              message == MovieDetailBloc.watchlistRemoveSuccessMessage) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          } else {
            showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(content: Text(message)),
            );
          }
        },
        builder: (context, provider) {
          if (provider.movieState == RequestState.Loading) {
            return const LoadingView();
          }
          if (provider.movieState == RequestState.Loaded &&
              provider.movie != null) {
            return DetailContent(
              provider.movie!,
              provider.movieRecommendations,
              provider.isAddedToWatchlist,
            );
          }
          return ErrorStateView(message: provider.message);
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  const DetailContent(
    this.movie,
    this.recommendations,
    this.isAddedWatchlist, {
    super.key,
  });

  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedWatchlist;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _DetailHeader(movie: movie),
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
                    RatingBadge(rating: movie.voteAverage),
                    _InfoChip(label: _showDuration(movie.runtime)),
                    if (movie.releaseDate.isNotEmpty)
                      _InfoChip(label: movie.releaseDate),
                  ],
                ),
                const SizedBox(height: 14),
                Text(_showGenres(movie.genres), style: kSubtitle),
                const SizedBox(height: 22),
                Text('Overview', style: kHeading6),
                const SizedBox(height: 8),
                Text(movie.overview, style: kBodyText),
                const SizedBox(height: 24),
                Text('Recommendations', style: kHeading6),
                const SizedBox(height: 12),
                BlocBuilder<MovieDetailBloc, MovieDetailState>(
                  builder: (context, data) {
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
                      return _RecommendationMovies(movies: recommendations);
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

  void _toggleWatchlist(BuildContext context) {
    final bloc = context.read<MovieDetailBloc>();
    if (!isAddedWatchlist) {
      bloc.add(AddMovieToWatchlist(movie));
    } else {
      bloc.add(RemoveMovieFromWatchlist(movie));
    }
  }

  String _showGenres(List<Genre> genres) {
    return genres.map((genre) => genre.name).join(', ');
  }

  String _showDuration(int runtime) {
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.movie});

  final MovieDetail movie;

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
                BackdropImageView(backdropPath: movie.backdropPath),
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
                  posterPath: movie.posterPath,
                  width: 116,
                  height: 174,
                  borderRadius: 8,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      movie.title,
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

class _RecommendationMovies extends StatelessWidget {
  const _RecommendationMovies({required this.movies});

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return const SizedBox(
        height: 150,
        child: EmptyStateView(
          title: 'No recommendations',
          message: 'Related movies are not available yet.',
          assetName: emptySearchAsset,
        ),
      );
    }

    return SizedBox(
      height: 154,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return SizedBox(
            width: 96,
            child: InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  MovieDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: PosterImageView(
                posterPath: movie.posterPath,
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
