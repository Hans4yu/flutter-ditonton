import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/analytics_helper.dart';
import 'package:ditonton/common/analytics_service.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_event.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_state.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

void main() {
  late MockMovieDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockMovieDetailBloc();
  });

  tearDown(() {
    configureAnalyticsResolver(() => null);
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  MovieDetailState loadedState({required bool isAdded}) {
    return MovieDetailState(
      movieState: RequestState.Loaded,
      movie: testMovieDetail,
      recommendationState: RequestState.Loaded,
      movieRecommendations: const [],
      isAddedToWatchlist: isAdded,
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (tester) async {
    whenListen(mockBloc, const Stream<MovieDetailState>.empty(),
        initialState: loadedState(isAdded: false));

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('logs movie detail opened event', (tester) async {
    final logger = RecordingAnalyticsLogger();
    configureAnalyticsResolver(() => AnalyticsService(logger));
    whenListen(mockBloc, const Stream<MovieDetailState>.empty(),
        initialState: loadedState(isAdded: false));

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
    await tester.pump();

    expect(logger.events, contains(AnalyticsEvents.movieDetailOpened));
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (tester) async {
    whenListen(mockBloc, const Stream<MovieDetailState>.empty(),
        initialState: loadedState(isAdded: true));

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (tester) async {
    final initialState = loadedState(isAdded: false);
    final successState = initialState.copyWith(
      isAddedToWatchlist: true,
      watchlistMessage: MovieDetailBloc.watchlistAddSuccessMessage,
    );
    whenListen(
      mockBloc,
      Stream<MovieDetailState>.fromIterable([successState]),
      initialState: initialState,
    );

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsWidgets);
  });

  testWidgets('logs movie add to watchlist event', (tester) async {
    final logger = RecordingAnalyticsLogger();
    configureAnalyticsResolver(() => AnalyticsService(logger));
    whenListen(mockBloc, const Stream<MovieDetailState>.empty(),
        initialState: loadedState(isAdded: false));

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(logger.events, contains(AnalyticsEvents.addToWatchlist));
  });

  testWidgets('logs movie remove from watchlist event', (tester) async {
    final logger = RecordingAnalyticsLogger();
    configureAnalyticsResolver(() => AnalyticsService(logger));
    whenListen(mockBloc, const Stream<MovieDetailState>.empty(),
        initialState: loadedState(isAdded: true));

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();

    expect(logger.events, contains(AnalyticsEvents.removeFromWatchlist));
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (tester) async {
    final initialState = loadedState(isAdded: false);
    final failureState = initialState.copyWith(watchlistMessage: 'Failed');
    whenListen(
      mockBloc,
      Stream<MovieDetailState>.fromIterable([failureState]),
      initialState: initialState,
    );

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}

class RecordingAnalyticsLogger implements AnalyticsLogger {
  final events = <String>[];

  @override
  Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    events.add(name);
  }
}
