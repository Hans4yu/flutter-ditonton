import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/domain/entities/movie.dart';
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

  testWidgets('MovieCard handles long text without vertical overflow',
      (tester) async {
    final movie = Movie(
      adult: false,
      backdropPath: null,
      genreIds: const [18],
      id: 42,
      originalTitle: 'A Very Long Movie Title That Should Stay Inside The Card',
      overview:
          'This overview is intentionally long to verify the fixed-height '
          'watchlist and list cards keep text constrained instead of '
          'overflowing vertically on compact Android screens.',
      popularity: 1,
      posterPath: null,
      releaseDate: '2026-01-01',
      title: 'A Very Long Movie Title That Should Stay Inside The Card',
      video: false,
      voteAverage: 8.4,
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
        home: Scaffold(body: MovieCard(movie)),
      ),
    );

    expect(find.byType(MovieCard), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
