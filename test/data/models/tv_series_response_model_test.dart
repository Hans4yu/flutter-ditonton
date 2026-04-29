import 'dart:convert';

import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

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
  final tResponseModel =
      TvSeriesResponse(tvSeriesList: <TvSeriesModel>[tTvSeriesModel]);

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/on_the_air_tv_series.json'));
      final result = TvSeriesResponse.fromJson(jsonMap);
      expect(result, tResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      final result = tResponseModel.toJson();
      final expectedJsonMap = {
        'results': [
          {
            'backdrop_path': '/tv-backdrop.jpg',
            'first_air_date': '2024-01-01',
            'genre_ids': [16, 10759],
            'id': 100,
            'name': 'Demon Slayer',
            'origin_country': ['JP'],
            'original_language': 'ja',
            'original_name': 'Kimetsu no Yaiba',
            'overview': 'Tanjiro joins the Demon Slayer Corps.',
            'popularity': 99.9,
            'poster_path': '/tv-poster.jpg',
            'vote_average': 8.8,
            'vote_count': 1200,
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
