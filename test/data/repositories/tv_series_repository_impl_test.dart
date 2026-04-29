import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/repositories/tv_series_repository_impl.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesRepositoryImpl repository;
  late MockTvSeriesRemoteDataSource mockRemoteDataSource;
  late MockTvSeriesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvSeriesRemoteDataSource();
    mockLocalDataSource = MockTvSeriesLocalDataSource();
    repository = TvSeriesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

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

  final tTvSeriesModelList = <TvSeriesModel>[tTvSeriesModel];
  final tTvSeriesList = <TvSeries>[testTvSeries];

  group('On The Air TV Series', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      when(mockRemoteDataSource.getOnTheAirTvSeries())
          .thenAnswer((_) async => tTvSeriesModelList);
      final result = await repository.getOnTheAirTvSeries();
      verify(mockRemoteDataSource.getOnTheAirTvSeries());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getOnTheAirTvSeries())
          .thenThrow(ServerException());
      final result = await repository.getOnTheAirTvSeries();
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      when(mockRemoteDataSource.getOnTheAirTvSeries())
          .thenThrow(const SocketException('Failed to connect to the network'));
      final result = await repository.getOnTheAirTvSeries();
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Popular TV Series', () {
    test('should return tv series list when call to data source is success',
        () async {
      when(mockRemoteDataSource.getPopularTvSeries())
          .thenAnswer((_) async => tTvSeriesModelList);
      final result = await repository.getPopularTvSeries();
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getPopularTvSeries())
          .thenThrow(ServerException());
      final result = await repository.getPopularTvSeries();
      expect(result, Left(ServerFailure('')));
    });
  });

  group('Top Rated TV Series', () {
    test('should return tv series list when call to data source is successful',
        () async {
      when(mockRemoteDataSource.getTopRatedTvSeries())
          .thenAnswer((_) async => tTvSeriesModelList);
      final result = await repository.getTopRatedTvSeries();
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getTopRatedTvSeries())
          .thenThrow(ServerException());
      final result = await repository.getTopRatedTvSeries();
      expect(result, Left(ServerFailure('')));
    });
  });

  group('Get TV Series Detail', () {
    const tId = 100;
    final tResponse = TvSeriesDetailResponse(
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

    test(
        'should return tv series data when the call to remote data source is successful',
        () async {
      when(mockRemoteDataSource.getTvSeriesDetail(tId))
          .thenAnswer((_) async => tResponse);
      final result = await repository.getTvSeriesDetail(tId);
      expect(result, equals(Right(testTvSeriesDetail)));
    });
  });

  group('Get TV Series Recommendations', () {
    const tId = 100;

    test('should return data when the call is successful', () async {
      when(mockRemoteDataSource.getTvSeriesRecommendations(tId))
          .thenAnswer((_) async => tTvSeriesModelList);
      final result = await repository.getTvSeriesRecommendations(tId);
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tTvSeriesList));
    });
  });

  group('Search TV Series', () {
    const tQuery = 'demon slayer';

    test('should return tv series list when call to data source is successful',
        () async {
      when(mockRemoteDataSource.searchTvSeries(tQuery))
          .thenAnswer((_) async => tTvSeriesModelList);
      final result = await repository.searchTvSeries(tQuery);
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      when(mockLocalDataSource.insertWatchlist(testTvSeriesTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      final result = await repository.saveWatchlist(testTvSeriesDetail);
      expect(result, const Right('Added to Watchlist'));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      when(mockLocalDataSource.removeWatchlist(testTvSeriesTable))
          .thenAnswer((_) async => 'Removed from Watchlist');
      final result = await repository.removeWatchlist(testTvSeriesDetail);
      expect(result, const Right('Removed from Watchlist'));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      const tId = 100;
      when(mockLocalDataSource.getTvSeriesById(tId))
          .thenAnswer((_) async => null);
      final result = await repository.isAddedToWatchlist(tId);
      expect(result, false);
    });
  });

  group('get watchlist tv series', () {
    test('should return list of tv series', () async {
      when(mockLocalDataSource.getWatchlistTvSeries())
          .thenAnswer((_) async => [testTvSeriesTable]);
      final result = await repository.getWatchlistTvSeries();
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTvSeries]);
    });
  });
}
