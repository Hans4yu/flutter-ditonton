import 'package:bloc_test/bloc_test.dart';
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
}
