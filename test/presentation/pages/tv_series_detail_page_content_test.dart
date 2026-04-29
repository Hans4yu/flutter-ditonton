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
  testWidgets(
      'tv series detail page renders season runtime and recommendations',
      (tester) async {
    final bloc = MockTvSeriesDetailBloc();
    whenListen(bloc, const Stream<TvSeriesDetailState>.empty(),
        initialState: TvSeriesDetailState(
          tvSeriesState: RequestState.Loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.Loaded,
          tvSeriesRecommendations: [testTvSeries],
        ));

    await tester.pumpWidget(
      BlocProvider<TvSeriesDetailBloc>.value(
        value: bloc,
        child: const MaterialApp(home: TvSeriesDetailPage(id: 100)),
      ),
    );

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -650));
    await tester.pump();

    expect(find.text('Seasons & Episodes'), findsOneWidget);
    expect(find.text('24m / episode'), findsOneWidget);
    expect(find.text('1 seasons • 11 episodes'), findsOneWidget);
    expect(find.text('Season 1'), findsWidgets);
    expect(find.text('Recommendations'), findsOneWidget);
  });
}
