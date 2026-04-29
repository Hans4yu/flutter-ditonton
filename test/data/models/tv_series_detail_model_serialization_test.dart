import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should convert tv series detail model to json', () {
    final model = TvSeriesDetailResponse(
      backdropPath: '/tv-backdrop.jpg',
      episodeRunTime: [24],
      firstAirDate: '2024-01-01',
      genres: [GenreModel(id: 1, name: 'Action')],
      id: 100,
      name: 'Demon Slayer',
      numberOfEpisodes: 11,
      numberOfSeasons: 1,
      originalName: 'Kimetsu no Yaiba',
      overview: 'Tanjiro joins the Demon Slayer Corps.',
      posterPath: '/tv-poster.jpg',
      seasons: [
        SeasonModel(
          airDate: '2024-01-01',
          episodeCount: 11,
          id: 10,
          name: 'Season 1',
          overview: 'season overview',
          posterPath: '/season.jpg',
          seasonNumber: 1,
        ),
      ],
      status: 'Ended',
      voteAverage: 8.8,
      voteCount: 1200,
    );

    final result = model.toJson();
    expect(result['episode_run_time'], [24]);
    expect(result['name'], 'Demon Slayer');
    expect(result['seasons'], isNotEmpty);
  });
}
