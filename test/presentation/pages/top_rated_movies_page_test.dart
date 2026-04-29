import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_movies_page_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late MockGetTopRatedMovies mockUsecase;

  setUp(() {
    mockUsecase = MockGetTopRatedMovies();
  });

  Widget makeTestableWidget() {
    return BlocProvider(
      create: (_) => TopRatedMoviesBloc(getTopRatedMovies: mockUsecase),
      child: MaterialApp(home: TopRatedMoviesPage()),
    );
  }

  testWidgets('Page should display progress bar when loading', (tester) async {
    final completer = Completer<Either<Failure, List<Movie>>>();
    when(mockUsecase.execute()).thenAnswer((_) => completer.future);

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(Center), findsOneWidget);
  });

  testWidgets('Page should display when data is loaded', (tester) async {
    when(mockUsecase.execute()).thenAnswer((_) async => const Right(<Movie>[]));

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (tester) async {
    when(mockUsecase.execute())
        .thenAnswer((_) async => const Left(ServerFailure('Error message')));

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });
}
