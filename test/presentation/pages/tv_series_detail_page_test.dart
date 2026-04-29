import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/analytics_helper.dart';
import 'package:ditonton/common/analytics_service.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_detail/tv_series_detail_event.dart';
import 'package:ditonton/presentation/bloc/tv_series_detail/tv_series_detail_state.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTvSeriesDetailBloc
    extends MockBloc<TvSeriesDetailEvent, TvSeriesDetailState>
    implements TvSeriesDetailBloc {}

void main() {
  late MockTvSeriesDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockTvSeriesDetailBloc();
  });

  tearDown(() {
    configureAnalyticsResolver(() => null);
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvSeriesDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  TvSeriesDetailState loadedState({required bool isAdded}) {
    return TvSeriesDetailState(
      tvSeriesState: RequestState.Loaded,
      tvSeries: testTvSeriesDetail,
      recommendationState: RequestState.Loaded,
      tvSeriesRecommendations: const [],
      isAddedToWatchlist: isAdded,
    );
  }

  testWidgets(
      'Watchlist button should display add icon when tv series not added to watchlist',
      (tester) async {
    whenListen(mockBloc, const Stream<TvSeriesDetailState>.empty(),
        initialState: loadedState(isAdded: false));

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 100)));

    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('logs tv series detail opened event', (tester) async {
    final logger = RecordingAnalyticsLogger();
    configureAnalyticsResolver(() => AnalyticsService(logger));
    whenListen(mockBloc, const Stream<TvSeriesDetailState>.empty(),
        initialState: loadedState(isAdded: false));

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 100)));
    await tester.pump();

    expect(logger.events, contains(AnalyticsEvents.tvDetailOpened));
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (tester) async {
    final initialState = loadedState(isAdded: false);
    final successState = initialState.copyWith(
      isAddedToWatchlist: true,
      watchlistMessage: TvSeriesDetailBloc.watchlistAddSuccessMessage,
    );
    whenListen(
      mockBloc,
      Stream<TvSeriesDetailState>.fromIterable([successState]),
      initialState: initialState,
    );

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 100)));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsWidgets);
  });

  testWidgets('logs tv series add to watchlist event', (tester) async {
    final logger = RecordingAnalyticsLogger();
    configureAnalyticsResolver(() => AnalyticsService(logger));
    whenListen(mockBloc, const Stream<TvSeriesDetailState>.empty(),
        initialState: loadedState(isAdded: false));

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 100)));
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(logger.events, contains(AnalyticsEvents.addToWatchlist));
  });

  testWidgets('logs tv series remove from watchlist event', (tester) async {
    final logger = RecordingAnalyticsLogger();
    configureAnalyticsResolver(() => AnalyticsService(logger));
    whenListen(mockBloc, const Stream<TvSeriesDetailState>.empty(),
        initialState: loadedState(isAdded: true));

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 100)));
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();

    expect(logger.events, contains(AnalyticsEvents.removeFromWatchlist));
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
