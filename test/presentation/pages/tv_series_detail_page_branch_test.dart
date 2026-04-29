import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_series_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_page_test.mocks.dart';

void main() {
  late MockTvSeriesDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTvSeriesDetailNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvSeriesDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        onGenerateRoute: (settings) {
          if (settings.name == TvSeriesDetailPage.ROUTE_NAME) {
            return MaterialPageRoute(
                builder: (_) =>
                    TvSeriesDetailPage(id: settings.arguments as int));
          }
          return MaterialPageRoute(builder: (_) => body);
        },
      ),
    );
  }

  testWidgets('tv series detail page shows error state', (tester) async {
    when(mockNotifier.fetchTvSeriesDetail(100)).thenAnswer((_) async {});
    when(mockNotifier.loadWatchlistStatus(100)).thenAnswer((_) async {});
    when(mockNotifier.tvSeriesState).thenReturn(RequestState.Error);
    when(mockNotifier.message).thenReturn('TV Error');

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 100)));

    expect(find.text('TV Error'), findsOneWidget);
  });

  testWidgets('tv series detail page shows dialog on failed watchlist action',
      (tester) async {
    when(mockNotifier.fetchTvSeriesDetail(100)).thenAnswer((_) async {});
    when(mockNotifier.loadWatchlistStatus(100)).thenAnswer((_) async {});
    when(mockNotifier.tvSeriesState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeries).thenReturn(testTvSeriesDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Error);
    when(mockNotifier.tvSeriesRecommendations)
        .thenReturn(<TvSeries>[testTvSeries]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(true);
    when(mockNotifier.watchlistMessage).thenReturn('Failed');
    when(mockNotifier.message).thenReturn('Recommendation Error');
    when(mockNotifier.removeFromWatchlist(testTvSeriesDetail))
        .thenAnswer((_) async {});

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 100)));
    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsWidgets);
  });
}
