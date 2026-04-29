import 'dart:async';

import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/presentation/provider/tv_series_list_notifier.dart';
import 'package:ditonton/presentation/widgets/cinematic_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeMoviePage extends StatefulWidget {
  const HomeMoviePage({super.key});

  @override
  State<HomeMoviePage> createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Provider.of<MovieListNotifier>(context, listen: false)
        ..fetchNowPlayingMovies()
        ..fetchPopularMovies()
        ..fetchTopRatedMovies();
      Provider.of<TvSeriesListNotifier>(context, listen: false)
        ..fetchOnTheAirTvSeries()
        ..fetchPopularTvSeries();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _HomeContent(),
      const SearchPage(showAppBar: false),
      const WatchlistMoviesPage(showAppBar: false),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border_rounded),
            selectedIcon: Icon(Icons.bookmark_rounded),
            label: 'Watchlist',
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: Text('Ditonton', style: kHeading5),
            ),
          ),
          SliverToBoxAdapter(
            child: Consumer<MovieListNotifier>(
              builder: (context, data, child) {
                if (data.nowPlayingState == RequestState.Loading) {
                  return const LoadingView(height: 240);
                }
                if (data.nowPlayingState == RequestState.Loaded) {
                  return HeroBannerCarousel(movies: data.nowPlayingMovies);
                }
                return ErrorStateView(message: data.message, height: 220);
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Consumer<MovieListNotifier>(
              builder: (context, data, child) {
                return _MovieSection(
                  title: 'Now Playing',
                  movies: data.nowPlayingMovies,
                  state: data.nowPlayingState,
                  message: data.message,
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Consumer<MovieListNotifier>(
              builder: (context, data, child) {
                return _MovieSection(
                  title: 'Popular',
                  movies: data.popularMovies,
                  state: data.popularMoviesState,
                  message: data.message,
                  onSeeAll: () {
                    Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME);
                  },
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Consumer<MovieListNotifier>(
              builder: (context, data, child) {
                return _MovieSection(
                  title: 'Top Rated',
                  movies: data.topRatedMovies,
                  state: data.topRatedMoviesState,
                  message: data.message,
                  onSeeAll: () {
                    Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME);
                  },
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Consumer<TvSeriesListNotifier>(
              builder: (context, data, child) {
                return _TvSection(
                  title: 'On The Air TV Series',
                  tvSeries: data.onTheAirTvSeries,
                  state: data.onTheAirState,
                  message: data.message,
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Consumer<TvSeriesListNotifier>(
              builder: (context, data, child) {
                return _TvSection(
                  title: 'Popular TV Series',
                  tvSeries: data.popularTvSeries,
                  state: data.popularTvSeriesState,
                  message: data.message,
                  onSeeAll: () {
                    Navigator.pushNamed(
                      context,
                      PopularTvSeriesPage.ROUTE_NAME,
                    );
                  },
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class HeroBannerCarousel extends StatefulWidget {
  const HeroBannerCarousel({required this.movies, super.key});

  final List<Movie> movies;

  @override
  State<HeroBannerCarousel> createState() => _HeroBannerCarouselState();
}

class _HeroBannerCarouselState extends State<HeroBannerCarousel> {
  final PageController _controller = PageController();
  Timer? _timer;
  Timer? _resumeTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void didUpdateWidget(covariant HeroBannerCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.movies.length != widget.movies.length) {
      _currentPage = 0;
      _startAutoSlide();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _resumeTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _timer?.cancel();
    if (widget.movies.length < 2) return;
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!_controller.hasClients || widget.movies.isEmpty) return;
      final nextPage = (_currentPage + 1) % widget.movies.length;
      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _pauseAfterInteraction() {
    _timer?.cancel();
    _resumeTimer?.cancel();
    _resumeTimer = Timer(const Duration(seconds: 4), _startAutoSlide);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) {
      return const EmptyStateView(
        title: 'No highlights available',
        message: 'Featured movies will appear here when content is available.',
        assetName: emptySearchAsset,
      );
    }

    return SizedBox(
      height: 260,
      child: GestureDetector(
        onPanDown: (_) => _pauseAfterInteraction(),
        child: PageView.builder(
          controller: _controller,
          itemCount: widget.movies.length,
          onPageChanged: (index) {
            setState(() => _currentPage = index);
          },
          itemBuilder: (context, index) {
            final movie = widget.movies[index];
            return _HeroBanner(movie: movie);
          },
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.pushNamed(
            context,
            MovieDetailPage.ROUTE_NAME,
            arguments: movie.id,
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
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
                      kRichBlack.withValues(alpha: 0.32),
                      kRichBlack.withValues(alpha: 0.94),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 18,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RatingBadge(rating: movie.voteAverage),
                    const SizedBox(height: 10),
                    Text(
                      movie.title ?? '-',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: kHeading5.copyWith(fontSize: 28),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MovieSection extends StatelessWidget {
  const _MovieSection({
    required this.title,
    required this.movies,
    required this.state,
    required this.message,
    this.onSeeAll,
  });

  final String title;
  final List<Movie> movies;
  final RequestState state;
  final String message;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(title: title, onSeeAll: onSeeAll),
        if (state == RequestState.Loading)
          const LoadingView(height: 154)
        else if (state == RequestState.Loaded)
          MovieHorizontalList(movies: movies)
        else
          ErrorStateView(message: message, height: 154),
      ],
    );
  }
}

class _TvSection extends StatelessWidget {
  const _TvSection({
    required this.title,
    required this.tvSeries,
    required this.state,
    required this.message,
    this.onSeeAll,
  });

  final String title;
  final List<TvSeries> tvSeries;
  final RequestState state;
  final String message;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(title: title, onSeeAll: onSeeAll),
        if (state == RequestState.Loading)
          const LoadingView(height: 154)
        else if (state == RequestState.Loaded)
          TvHorizontalList(tvSeries: tvSeries)
        else
          ErrorStateView(message: message, height: 154),
      ],
    );
  }
}

class MovieHorizontalList extends StatelessWidget {
  const MovieHorizontalList({required this.movies, super.key});

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return const SizedBox(
        height: 154,
        child: EmptyStateView(
          title: 'No titles available',
          message: 'This section is currently empty.',
          assetName: emptySearchAsset,
        ),
      );
    }

    return SizedBox(
      height: 154,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return _HorizontalContentCard(
            title: movie.title ?? '-',
            overview: movie.overview,
            posterPath: movie.posterPath,
            rating: movie.voteAverage,
            onTap: () {
              Navigator.pushNamed(
                context,
                MovieDetailPage.ROUTE_NAME,
                arguments: movie.id,
              );
            },
          );
        },
      ),
    );
  }
}

class TvHorizontalList extends StatelessWidget {
  const TvHorizontalList({required this.tvSeries, super.key});

  final List<TvSeries> tvSeries;

  @override
  Widget build(BuildContext context) {
    if (tvSeries.isEmpty) {
      return const SizedBox(
        height: 154,
        child: EmptyStateView(
          title: 'No series available',
          message: 'This section is currently empty.',
          assetName: emptySearchAsset,
        ),
      );
    }

    return SizedBox(
      height: 154,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: tvSeries.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = tvSeries[index];
          return _HorizontalContentCard(
            title: item.name ?? '-',
            overview: item.overview,
            posterPath: item.posterPath,
            rating: item.voteAverage,
            onTap: () {
              Navigator.pushNamed(
                context,
                TvSeriesDetailPage.ROUTE_NAME,
                arguments: item.id,
              );
            },
          );
        },
      ),
    );
  }
}

class _HorizontalContentCard extends StatelessWidget {
  const _HorizontalContentCard({
    required this.title,
    required this.posterPath,
    required this.onTap,
    this.overview,
    this.rating,
  });

  final String title;
  final String? overview;
  final String? posterPath;
  final double? rating;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Material(
        color: kSurfaceCard,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                PosterImageView(
                  posterPath: posterPath,
                  width: 88,
                  height: 132,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: kHeading6.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      RatingBadge(rating: rating, compact: true),
                      const Spacer(),
                      Text(
                        overview == null || overview!.isEmpty
                            ? 'Overview unavailable'
                            : overview!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: kBodyText,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
