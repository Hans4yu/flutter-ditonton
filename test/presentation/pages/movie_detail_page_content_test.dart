import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_page_content_test.mocks.dart';

@GenerateMocks([MovieDetailNotifier])
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

  testWidgets('movie detail page renders overview genres and recommendations',
      (tester) async {
    when(mockNotifier.fetchMovieDetail(1)).thenAnswer((_) async {});
    when(mockNotifier.loadWatchlistStatus(1)).thenAnswer((_) async {});
    when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movie).thenReturn(testMovieDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movieRecommendations).thenReturn(<Movie>[testMovie]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
    await tester.pump();

    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Action'), findsOneWidget);
    expect(find.text('2h 0m'), findsOneWidget);
    expect(find.text('Recommendations'), findsOneWidget);
  });
}
