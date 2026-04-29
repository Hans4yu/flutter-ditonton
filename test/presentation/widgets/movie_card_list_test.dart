import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  testWidgets('MovieCard renders content and navigates to detail route',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          MovieDetailPage.ROUTE_NAME: (_) =>
              const Scaffold(body: Text('movie detail')),
        },
        home: Scaffold(body: MovieCard(testMovie)),
      ),
    );

    expect(find.text('Spider-Man'), findsOneWidget);
    expect(find.textContaining('After being bitten'), findsOneWidget);

    await tester.tap(find.byType(MovieCard));
    await tester.pumpAndSettle();

    expect(find.text('movie detail'), findsOneWidget);
  });
}
