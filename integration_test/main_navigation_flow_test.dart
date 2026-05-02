import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_list/movie_list_event.dart';
import 'package:ditonton/presentation/bloc/movie_list/movie_list_state.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_event.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_state.dart';
import 'package:ditonton/presentation/bloc/tv_series_list/tv_series_list_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_list/tv_series_list_event.dart';
import 'package:ditonton/presentation/bloc/tv_series_list/tv_series_list_state.dart';
import 'package:ditonton/presentation/bloc/tv_series_search/tv_series_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_search/tv_series_search_event.dart';
import 'package:ditonton/presentation/bloc/tv_series_search/tv_series_search_state.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie/watchlist_movie_event.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie/watchlist_movie_state.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_series/watchlist_tv_series_event.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_series/watchlist_tv_series_state.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/dummy_data/dummy_objects.dart';

class MockMovieListBloc extends MockBloc<MovieListEvent, MovieListState>
    implements MovieListBloc {}

class MockTvSeriesListBloc
    extends MockBloc<TvSeriesListEvent, TvSeriesListState>
    implements TvSeriesListBloc {}

class MockMovieSearchBloc extends MockBloc<MovieSearchEvent, MovieSearchState>
    implements MovieSearchBloc {}

class MockTvSeriesSearchBloc
    extends MockBloc<TvSeriesSearchEvent, TvSeriesSearchState>
    implements TvSeriesSearchBloc {}

class MockWatchlistMovieBloc
    extends MockBloc<WatchlistMovieEvent, WatchlistMovieState>
    implements WatchlistMovieBloc {}

class MockWatchlistTvSeriesBloc
    extends MockBloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState>
    implements WatchlistTvSeriesBloc {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockMovieListBloc movieListBloc;
  late MockTvSeriesListBloc tvSeriesListBloc;
  late MockMovieSearchBloc movieSearchBloc;
  late MockTvSeriesSearchBloc tvSeriesSearchBloc;
  late MockWatchlistMovieBloc watchlistMovieBloc;
  late MockWatchlistTvSeriesBloc watchlistTvSeriesBloc;

  setUp(() {
    movieListBloc = MockMovieListBloc();
    tvSeriesListBloc = MockTvSeriesListBloc();
    movieSearchBloc = MockMovieSearchBloc();
    tvSeriesSearchBloc = MockTvSeriesSearchBloc();
    watchlistMovieBloc = MockWatchlistMovieBloc();
    watchlistTvSeriesBloc = MockWatchlistTvSeriesBloc();

    whenListen(
      movieListBloc,
      const Stream<MovieListState>.empty(),
      initialState: MovieListState(
        nowPlayingState: RequestState.Loaded,
        nowPlayingMovies: [testMovie],
        popularMoviesState: RequestState.Loaded,
        popularMovies: [testMovie],
        topRatedMoviesState: RequestState.Loaded,
        topRatedMovies: [testMovie],
      ),
    );
    whenListen(
      tvSeriesListBloc,
      const Stream<TvSeriesListState>.empty(),
      initialState: TvSeriesListState(
        onTheAirState: RequestState.Loaded,
        onTheAirTvSeries: [testTvSeries],
        popularTvSeriesState: RequestState.Loaded,
        popularTvSeries: [testTvSeries],
        topRatedTvSeriesState: RequestState.Loaded,
        topRatedTvSeries: [testTvSeries],
      ),
    );
    whenListen(
      movieSearchBloc,
      const Stream<MovieSearchState>.empty(),
      initialState: const MovieSearchState(),
    );
    whenListen(
      tvSeriesSearchBloc,
      const Stream<TvSeriesSearchState>.empty(),
      initialState: const TvSeriesSearchState(),
    );
    whenListen(
      watchlistMovieBloc,
      const Stream<WatchlistMovieState>.empty(),
      initialState: const WatchlistMovieState(
        watchlistState: RequestState.Loaded,
      ),
    );
    whenListen(
      watchlistTvSeriesBloc,
      const Stream<WatchlistTvSeriesState>.empty(),
      initialState: const WatchlistTvSeriesState(
        watchlistState: RequestState.Loaded,
      ),
    );
  });

  testWidgets('main navigation exposes home search and watchlist flows',
      (tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<MovieListBloc>.value(value: movieListBloc),
          BlocProvider<TvSeriesListBloc>.value(value: tvSeriesListBloc),
          BlocProvider<MovieSearchBloc>.value(value: movieSearchBloc),
          BlocProvider<TvSeriesSearchBloc>.value(value: tvSeriesSearchBloc),
          BlocProvider<WatchlistMovieBloc>.value(value: watchlistMovieBloc),
          BlocProvider<WatchlistTvSeriesBloc>.value(
            value: watchlistTvSeriesBloc,
          ),
        ],
        child: MaterialApp(
          theme: ThemeData.dark().copyWith(
            colorScheme: kColorScheme,
            primaryColor: kRichBlack,
            scaffoldBackgroundColor: kRichBlack,
            textTheme: kTextTheme,
            navigationBarTheme: NavigationBarThemeData(
              backgroundColor: kBackgroundSecondary,
              indicatorColor: kAccentRed,
              iconTheme: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const IconThemeData(color: kTextPrimary);
                }
                return const IconThemeData(color: kTextSecondary);
              }),
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                final color = states.contains(WidgetState.selected)
                    ? kTextPrimary
                    : kTextSecondary;
                return kBodyText.copyWith(color: color);
              }),
            ),
            tabBarTheme: TabBarThemeData(
              labelColor: kTextPrimary,
              unselectedLabelColor: kTextSecondary,
              indicatorColor: kAccentRed,
              labelStyle: kSubtitle.copyWith(color: kTextPrimary),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: kSurfaceCard,
              hintStyle: kBodyText,
              prefixIconColor: kTextSecondary,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: kBorderSubtle),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: kAccentRed),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          home: const HomeMoviePage(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Now Playing'), findsOneWidget);
    await _scrollHomeUntilVisible(tester, 'Popular TV Series');
    await _scrollHomeUntilVisible(tester, 'Top Rated TV Series');

    await tester.tap(_navigationDestination('Search'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('TV Series'), findsOneWidget);
    expect(find.text('Search movie titles'), findsOneWidget);

    await tester.tap(find.text('TV Series').last);
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Search TV series titles'), findsOneWidget);

    await tester.tap(_navigationDestination('Watchlist'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Watchlist'), findsWidgets);
    expect(find.text('No saved movies'), findsOneWidget);
  });
}

Finder _navigationDestination(String label) {
  return find.byWidgetPredicate(
    (widget) => widget is NavigationDestination && widget.label == label,
  );
}

Future<void> _scrollHomeUntilVisible(
  WidgetTester tester,
  String text,
) async {
  final target = find.text(text);
  for (var attempt = 0; attempt < 6; attempt++) {
    if (target.evaluate().isNotEmpty) return;
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
    await tester.pump(const Duration(milliseconds: 300));
  }
  expect(target, findsOneWidget);
}
