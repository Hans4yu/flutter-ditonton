import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  testWidgets('TvSeriesCard renders content and navigates to detail route',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          TvSeriesDetailPage.ROUTE_NAME: (_) =>
              const Scaffold(body: Text('tv detail')),
        },
        home: Scaffold(body: TvSeriesCard(testTvSeries)),
      ),
    );

    expect(find.text('Demon Slayer'), findsOneWidget);
    expect(find.textContaining('Tanjiro joins'), findsOneWidget);

    await tester.tap(find.byType(TvSeriesCard));
    await tester.pumpAndSettle();

    expect(find.text('tv detail'), findsOneWidget);
  });

  testWidgets('TvSeriesCard handles long text without vertical overflow',
      (tester) async {
    final tvSeries = TvSeries(
      backdropPath: null,
      firstAirDate: '2026-01-01',
      genreIds: const [18],
      id: 77,
      name: 'A Very Long Series Title That Should Stay Inside The Card',
      originCountry: const ['US'],
      originalLanguage: 'en',
      originalName: 'A Very Long Series Title',
      overview:
          'This overview is intentionally long to verify the fixed-height '
          'watchlist and list cards keep text constrained instead of '
          'overflowing vertically on compact Android screens.',
      popularity: 1,
      posterPath: null,
      voteAverage: 8.1,
      voteCount: 10,
    );

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.35),
          ),
          child: child!,
        ),
        home: Scaffold(body: TvSeriesCard(tvSeries)),
      ),
    );

    expect(find.byType(TvSeriesCard), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
