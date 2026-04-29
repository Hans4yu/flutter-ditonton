import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
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
      child: MaterialApp(
        onGenerateRoute: (settings) {
          if (settings.name == TvSeriesDetailPage.ROUTE_NAME) {
            return MaterialPageRoute(
              builder: (_) => TvSeriesDetailPage(id: settings.arguments as int),
            );
          }
          return MaterialPageRoute(builder: (_) => body);
        },
      ),
    );
  }

  testWidgets('tv series detail page shows error state', (tester) async {
    whenListen(mockBloc, const Stream<TvSeriesDetailState>.empty(),
        initialState: const TvSeriesDetailState(
          tvSeriesState: RequestState.Error,
          message: 'TV Error',
        ));

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 100)));

    expect(find.text('TV Error'), findsOneWidget);
  });

  testWidgets('tv series detail page shows dialog on failed watchlist action',
      (tester) async {
    final initialState = TvSeriesDetailState(
      tvSeriesState: RequestState.Loaded,
      tvSeries: testTvSeriesDetail,
      recommendationState: RequestState.Error,
      tvSeriesRecommendations: const <TvSeries>[],
      isAddedToWatchlist: true,
      message: 'Recommendation Error',
    );
    final failureState = initialState.copyWith(watchlistMessage: 'Failed');
    whenListen(
      mockBloc,
      Stream<TvSeriesDetailState>.fromIterable([failureState]),
      initialState: initialState,
    );

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 100)));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsWidgets);
  });
}
