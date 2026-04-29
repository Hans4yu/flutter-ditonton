import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_page_test.mocks.dart';

void main() {
  late MockMovieDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockMovieDetailNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<MovieDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('movie detail page shows loading state', (tester) async {
    when(mockNotifier.fetchMovieDetail(1)).thenAnswer((_) async {});
    when(mockNotifier.loadWatchlistStatus(1)).thenAnswer((_) async {});
    when(mockNotifier.movieState).thenReturn(RequestState.Loading);

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('movie detail page shows error state', (tester) async {
    when(mockNotifier.fetchMovieDetail(1)).thenAnswer((_) async {});
    when(mockNotifier.loadWatchlistStatus(1)).thenAnswer((_) async {});
    when(mockNotifier.movieState).thenReturn(RequestState.Error);
    when(mockNotifier.message).thenReturn('Movie Error');

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.text('Movie Error'), findsOneWidget);
  });

  testWidgets(
      'movie detail page handles remove watchlist and recommendation error',
      (tester) async {
    when(mockNotifier.fetchMovieDetail(1)).thenAnswer((_) async {});
    when(mockNotifier.loadWatchlistStatus(1)).thenAnswer((_) async {});
    when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movie).thenReturn(testMovieDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Error);
    when(mockNotifier.movieRecommendations).thenReturn(<Movie>[testMovie]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(true);
    when(mockNotifier.watchlistMessage).thenReturn('Removed from Watchlist');
    when(mockNotifier.message).thenReturn('Recommendation Error');
    when(mockNotifier.removeFromWatchlist(testMovieDetail))
        .thenAnswer((_) async {});

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -450));
    await tester.pump();

    expect(find.text('Recommendation Error'), findsOneWidget);
    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    expect(find.text('Removed from Watchlist'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('movie detail page renders minute duration variant',
      (tester) async {
    final shortMovie = MovieDetail(
      adult: false,
      backdropPath: 'backdropPath',
      genres: [Genre(id: 1, name: 'Action')],
      id: 2,
      originalTitle: 'originalTitle',
      overview: 'overview',
      posterPath: 'posterPath',
      releaseDate: 'releaseDate',
      runtime: 45,
      title: 'title',
      voteAverage: 1,
      voteCount: 1,
    );

    when(mockNotifier.fetchMovieDetail(2)).thenAnswer((_) async {});
    when(mockNotifier.loadWatchlistStatus(2)).thenAnswer((_) async {});
    when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movie).thenReturn(shortMovie);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Empty);
    when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 2)));

    expect(find.text('45m'), findsOneWidget);
  });
}
