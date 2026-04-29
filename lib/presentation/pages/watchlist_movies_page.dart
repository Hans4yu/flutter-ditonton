import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie/watchlist_movie_event.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie/watchlist_movie_state.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_series/watchlist_tv_series_event.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_series/watchlist_tv_series_state.dart';
import 'package:ditonton/presentation/widgets/cinematic_widgets.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistMoviesPage extends StatefulWidget {
  const WatchlistMoviesPage({this.showAppBar = true, super.key});

  static const ROUTE_NAME = '/watchlist-movie';

  final bool showAppBar;

  @override
  State<WatchlistMoviesPage> createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _fetchWatchlists();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    _fetchWatchlists();
  }

  void _fetchWatchlists() {
    context.read<WatchlistMovieBloc>().add(const FetchWatchlistMovies());
    context.read<WatchlistTvSeriesBloc>().add(const FetchWatchlistTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    final content = DefaultTabController(
      length: 2,
      child: SafeArea(
        top: !widget.showAppBar,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!widget.showAppBar) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text('Watchlist', style: kHeading5),
              ),
            ],
            const TabBar(
              tabs: [
                Tab(text: 'Movies'),
                Tab(text: 'TV Series'),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  _WatchlistMoviesContent(),
                  _WatchlistTvSeriesContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (!widget.showAppBar) return content;

    return Scaffold(
      appBar: AppBar(title: const Text('Watchlist')),
      body: content,
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}

class _WatchlistMoviesContent extends StatelessWidget {
  const _WatchlistMoviesContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistMovieBloc, WatchlistMovieState>(
      builder: (context, data) {
        if (data.watchlistState == RequestState.Loading) {
          return const LoadingView();
        }
        if (data.watchlistState == RequestState.Loaded) {
          if (data.watchlistMovies.isEmpty) {
            return const EmptyStateView(
              title: 'No saved movies',
              message: 'Movies added to your watchlist will appear here.',
              assetName: emptyWatchlistAsset,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final movie = data.watchlistMovies[index];
              return MovieCard(movie);
            },
            itemCount: data.watchlistMovies.length,
          );
        }
        return ErrorStateView(
            key: const Key('error_message'), message: data.message);
      },
    );
  }
}

class _WatchlistTvSeriesContent extends StatelessWidget {
  const _WatchlistTvSeriesContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      builder: (context, data) {
        if (data.watchlistState == RequestState.Loading) {
          return const LoadingView();
        }
        if (data.watchlistState == RequestState.Loaded) {
          if (data.watchlistTvSeries.isEmpty) {
            return const EmptyStateView(
              title: 'No saved TV series',
              message: 'TV series added to your watchlist will appear here.',
              assetName: emptyWatchlistAsset,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final tvSeries = data.watchlistTvSeries[index];
              return TvSeriesCard(tvSeries);
            },
            itemCount: data.watchlistTvSeries.length,
          );
        }
        return ErrorStateView(
            key: const Key('error_message'), message: data.message);
      },
    );
  }
}
