import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_series_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
  voteAverage: 1,
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
  voteAverage: 1,
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
  'voteAverage': 1.0,
};

final testSeason = Season(
  airDate: '2024-01-01',
  episodeCount: 11,
  id: 10,
  name: 'Season 1',
  overview: 'season overview',
  posterPath: '/season.jpg',
  seasonNumber: 1,
);

final testTvSeries = TvSeries(
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

final testTvSeriesList = [testTvSeries];

final testTvSeriesDetail = TvSeriesDetail(
  backdropPath: '/tv-backdrop.jpg',
  episodeRunTime: [24],
  firstAirDate: '2024-01-01',
  genres: [Genre(id: 1, name: 'Action')],
  id: 100,
  name: 'Demon Slayer',
  numberOfEpisodes: 11,
  numberOfSeasons: 1,
  originalName: 'Kimetsu no Yaiba',
  overview: 'Tanjiro joins the Demon Slayer Corps.',
  posterPath: '/tv-poster.jpg',
  seasons: [testSeason],
  status: 'Ended',
  voteAverage: 8.8,
  voteCount: 1200,
);

final testWatchlistTvSeries = TvSeries.watchlist(
  id: 100,
  name: 'Demon Slayer',
  posterPath: '/tv-poster.jpg',
  overview: 'Tanjiro joins the Demon Slayer Corps.',
  voteAverage: 8.8,
);

final testTvSeriesTable = TvSeriesTable(
  id: 100,
  name: 'Demon Slayer',
  posterPath: '/tv-poster.jpg',
  overview: 'Tanjiro joins the Demon Slayer Corps.',
  voteAverage: 8.8,
);

final testTvSeriesMap = {
  'id': 100,
  'name': 'Demon Slayer',
  'posterPath': '/tv-poster.jpg',
  'overview': 'Tanjiro joins the Demon Slayer Corps.',
  'voteAverage': 8.8,
};
