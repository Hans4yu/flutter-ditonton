import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_event.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_state.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

void main() {
  late MockMovieDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockMovieDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('movie detail page shows loading state', (tester) async {
    whenListen(mockBloc, const Stream<MovieDetailState>.empty(),
        initialState: const MovieDetailState(
          movieState: RequestState.Loading,
        ));

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('movie detail page shows error state', (tester) async {
    whenListen(mockBloc, const Stream<MovieDetailState>.empty(),
        initialState: const MovieDetailState(
          movieState: RequestState.Error,
          message: 'Movie Error',
        ));

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.text('Movie Error'), findsOneWidget);
  });

  testWidgets(
      'movie detail page handles remove watchlist and recommendation error',
      (tester) async {
    final initialState = MovieDetailState(
      movieState: RequestState.Loaded,
      movie: testMovieDetail,
      recommendationState: RequestState.Error,
      movieRecommendations: const <Movie>[],
      isAddedToWatchlist: true,
      message: 'Recommendation Error',
    );
    final successState = initialState.copyWith(
      watchlistMessage: MovieDetailBloc.watchlistRemoveSuccessMessage,
    );
    whenListen(
      mockBloc,
      Stream<MovieDetailState>.fromIterable([successState]),
      initialState: initialState,
    );

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -450));
    await tester.pump();

    expect(find.text('Recommendation Error'), findsOneWidget);
    expect(find.text('Removed from Watchlist'), findsWidgets);
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

    whenListen(mockBloc, const Stream<MovieDetailState>.empty(),
        initialState: MovieDetailState(
          movieState: RequestState.Loaded,
          movie: shortMovie,
          recommendationState: RequestState.Empty,
          movieRecommendations: const <Movie>[],
        ));

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 2)));

    expect(find.text('45m'), findsOneWidget);
  });
}
