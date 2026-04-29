import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
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
}
