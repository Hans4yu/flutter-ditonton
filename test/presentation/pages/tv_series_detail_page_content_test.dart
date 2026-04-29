import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_series_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_page_content_test.mocks.dart';

@GenerateMocks([TvSeriesDetailNotifier])
void main() {
  late MockTvSeriesDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTvSeriesDetailNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvSeriesDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
      'tv series detail page renders season runtime and recommendations',
      (tester) async {
    when(mockNotifier.fetchTvSeriesDetail(100)).thenAnswer((_) async {});
    when(mockNotifier.loadWatchlistStatus(100)).thenAnswer((_) async {});
    when(mockNotifier.tvSeriesState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeries).thenReturn(testTvSeriesDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeriesRecommendations)
        .thenReturn(<TvSeries>[testTvSeries]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 100)));

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -650));
    await tester.pump();

    expect(find.text('Seasons & Episodes'), findsOneWidget);
    expect(find.text('24m / episode'), findsOneWidget);
    expect(find.text('1 seasons • 11 episodes'), findsOneWidget);
    expect(find.text('Season 1'), findsWidgets);
    expect(find.text('Recommendations'), findsOneWidget);
  });
}
