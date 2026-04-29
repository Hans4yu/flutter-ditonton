import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_movies_page_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late MockGetPopularMovies mockUsecase;

  setUp(() {
    mockUsecase = MockGetPopularMovies();
  });

  Widget makeTestableWidget() {
    return BlocProvider(
      create: (_) => PopularMoviesBloc(mockUsecase),
      child: MaterialApp(home: PopularMoviesPage()),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (tester) async {
    final completer = Completer<Either<Failure, List<Movie>>>();
    when(mockUsecase.execute()).thenAnswer((_) => completer.future);

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(Center), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (tester) async {
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
