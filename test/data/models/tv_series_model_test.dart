import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  final tTvSeriesModel = TvSeriesModel(
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
  );

  test('should be a subclass of TvSeries entity', () async {
    final result = tTvSeriesModel.toEntity();
    expect(result, testTvSeries);
  });
}
