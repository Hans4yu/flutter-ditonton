import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/presentation/bloc/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'popular_tv_series_page_test.mocks.dart';

@GenerateMocks([GetPopularTvSeries])
void main() {
  late MockGetPopularTvSeries mockUsecase;

  setUp(() {
    mockUsecase = MockGetPopularTvSeries();
  });

  Widget makeTestableWidget() {
    return BlocProvider(
      create: (_) => PopularTvSeriesBloc(mockUsecase),
      child: const MaterialApp(home: PopularTvSeriesPage()),
    );
  }

  testWidgets('Page should display progress bar when loading', (tester) async {
    final completer = Completer<Either<Failure, List<TvSeries>>>();
    when(mockUsecase.execute()).thenAnswer((_) => completer.future);

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (tester) async {
    when(mockUsecase.execute())
        .thenAnswer((_) async => Right(testTvSeriesList));

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(ListView), findsOneWidget);
  });
}
