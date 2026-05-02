import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_event.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_state.dart';
import 'package:ditonton/presentation/bloc/tv_series_search/tv_series_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_search/tv_series_search_event.dart';
import 'package:ditonton/presentation/bloc/tv_series_search/tv_series_search_state.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieSearchBloc extends MockBloc<MovieSearchEvent, MovieSearchState>
    implements MovieSearchBloc {}

class MockTvSeriesSearchBloc
    extends MockBloc<TvSeriesSearchEvent, TvSeriesSearchState>
    implements TvSeriesSearchBloc {}

void main() {
  late MockMovieSearchBloc movieSearchBloc;
  late MockTvSeriesSearchBloc tvSeriesSearchBloc;

  setUp(() {
    movieSearchBloc = MockMovieSearchBloc();
    tvSeriesSearchBloc = MockTvSeriesSearchBloc();
  });

  Widget makeTestableWidget({
    MovieSearchState movieState = const MovieSearchState(),
    TvSeriesSearchState tvSeriesState = const TvSeriesSearchState(),
    bool showAppBar = false,
  }) {
    whenListen(
      movieSearchBloc,
      const Stream<MovieSearchState>.empty(),
      initialState: movieState,
    );
    whenListen(
      tvSeriesSearchBloc,
      const Stream<TvSeriesSearchState>.empty(),
      initialState: tvSeriesState,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieSearchBloc>.value(value: movieSearchBloc),
        BlocProvider<TvSeriesSearchBloc>.value(value: tvSeriesSearchBloc),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: SearchPage(showAppBar: showAppBar),
        ),
      ),
    );
  }

  testWidgets('Search page exposes movie and tv series tabs', (tester) async {
    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('TV Series'), findsOneWidget);
    expect(find.text('Search movie titles'), findsOneWidget);

    await tester.drag(find.byType(TabBarView), const Offset(-500, 0));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Search TV series titles'), findsOneWidget);
    expect(find.text('Search the TV catalog'), findsOneWidget);
  });

  testWidgets('Search page shows movie grid results', (tester) async {
    await tester.pumpWidget(makeTestableWidget(
      movieState: MovieSearchState(
        state: RequestState.Loaded,
        searchResult: [testMovie],
      ),
    ));

    expect(find.text('Spider-Man'), findsOneWidget);
    expect(find.text('7.2'), findsOneWidget);
  });

  testWidgets('Search page shows tv series grid results', (tester) async {
    await tester.pumpWidget(makeTestableWidget(
      tvSeriesState: TvSeriesSearchState(
        state: RequestState.Loaded,
        searchResult: [testTvSeries],
      ),
    ));

    await tester.drag(find.byType(TabBarView), const Offset(-500, 0));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Demon Slayer'), findsOneWidget);
    expect(find.text('8.8'), findsOneWidget);
  });

  testWidgets('Search page shows movie and tv error states', (tester) async {
    await tester.pumpWidget(makeTestableWidget(
      movieState: const MovieSearchState(
        state: RequestState.Error,
        message: 'Movie Error',
      ),
      tvSeriesState: const TvSeriesSearchState(
        state: RequestState.Error,
        message: 'TV Error',
      ),
    ));

    expect(find.text('Movie Error'), findsOneWidget);

    await tester.drag(find.byType(TabBarView), const Offset(-500, 0));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('TV Error'), findsOneWidget);
  });

  testWidgets('Search page handles app bar and loading states', (tester) async {
    await tester.pumpWidget(makeTestableWidget(
      showAppBar: true,
      movieState: const MovieSearchState(state: RequestState.Loading),
      tvSeriesState: const TvSeriesSearchState(state: RequestState.Loading),
    ));

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsWidgets);

    await tester.drag(find.byType(TabBarView), const Offset(-500, 0));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });
}
