import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:ditonton/presentation/provider/top_rated_tv_series_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'top_rated_tv_series_page_test.mocks.dart';

@GenerateMocks([TopRatedTvSeriesNotifier])
void main() {
  late MockTopRatedTvSeriesNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTopRatedTvSeriesNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TopRatedTvSeriesNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading', (tester) async {
    when(mockNotifier.fetchTopRatedTvSeries()).thenAnswer((_) async {});
    when(mockNotifier.state).thenReturn(RequestState.Loading);
    await tester.pumpWidget(makeTestableWidget(const TopRatedTvSeriesPage()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (tester) async {
    when(mockNotifier.fetchTopRatedTvSeries()).thenAnswer((_) async {});
    when(mockNotifier.state).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeries).thenReturn(testTvSeriesList);
    await tester.pumpWidget(makeTestableWidget(const TopRatedTvSeriesPage()));
    expect(find.byType(ListView), findsOneWidget);
  });
}
