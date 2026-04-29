import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:ditonton/presentation/pages/search_tv_series_page.dart';
import 'package:ditonton/presentation/provider/tv_series_search_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('TV series search flow shows API-backed results', (tester) async {
    final repository = _FakeTvSeriesRepository();

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => TvSeriesSearchNotifier(
          searchTvSeries: SearchTvSeries(repository),
        ),
        child: const MaterialApp(
          home: SearchTvSeriesPage(),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'demon slayer');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(find.text('Demon Slayer'), findsOneWidget);
    expect(find.text('Search Result'), findsOneWidget);
  });
}

class _FakeTvSeriesRepository implements TvSeriesRepository {
  @override
  Future<Either<Failure, List<TvSeries>>> searchTvSeries(String query) async {
    return Right([
      TvSeries(
        backdropPath: '/tv-backdrop.jpg',
        firstAirDate: '2024-01-01',
        genreIds: [16, 10759],
        id: 100,
        name: 'Demon Slayer',
        originCountry: ['JP'],
        originalLanguage: 'ja',
        originalName: 'Kimetsu no Yaiba',
        overview: 'Tanjiro joins the Demon Slayer Corps.',
        popularity: 99.9,
        posterPath: '/tv-poster.jpg',
        voteAverage: 8.8,
        voteCount: 1200,
      ),
    ]);
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getOnTheAirTvSeries() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getPopularTvSeries() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getTopRatedTvSeries() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, TvSeriesDetail>> getTvSeriesDetail(int id) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getTvSeriesRecommendations(int id) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(TvSeriesDetail tvSeries) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(TvSeriesDetail tvSeries) {
    throw UnimplementedError();
  }

  @override
  Future<bool> isAddedToWatchlist(int id) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getWatchlistTvSeries() {
    throw UnimplementedError();
  }
}
