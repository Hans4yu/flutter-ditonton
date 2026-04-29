import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
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
  testWidgets('movie detail page renders overview genres and recommendations',
      (tester) async {
    final bloc = MockMovieDetailBloc();
    whenListen(bloc, const Stream<MovieDetailState>.empty(),
        initialState: MovieDetailState(
          movieState: RequestState.Loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.Loaded,
          movieRecommendations: [testMovie],
        ));

    await tester.pumpWidget(
      BlocProvider<MovieDetailBloc>.value(
        value: bloc,
        child: MaterialApp(home: MovieDetailPage(id: 1)),
      ),
    );

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
    await tester.pump();

    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Action'), findsOneWidget);
    expect(find.text('2h 0m'), findsOneWidget);
    expect(find.text('Recommendations'), findsOneWidget);
  });
}
