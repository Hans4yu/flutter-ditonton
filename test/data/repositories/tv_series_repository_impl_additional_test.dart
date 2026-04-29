import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/repositories/tv_series_repository_impl.dart';
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

  test('should return connection failure for popular tv series', () async {
    when(mockRemoteDataSource.getPopularTvSeries())
        .thenThrow(const SocketException('Failed to connect to the network'));
    final result = await repository.getPopularTvSeries();
    expect(result, Left(ConnectionFailure('Failed to connect to the network')));
  });

  test('should return connection failure for top rated tv series', () async {
    when(mockRemoteDataSource.getTopRatedTvSeries())
        .thenThrow(const SocketException('Failed to connect to the network'));
    final result = await repository.getTopRatedTvSeries();
    expect(result, Left(ConnectionFailure('Failed to connect to the network')));
  });

  test('should return server failure for tv series detail', () async {
    when(mockRemoteDataSource.getTvSeriesDetail(100))
        .thenThrow(ServerException());
    final result = await repository.getTvSeriesDetail(100);
    expect(result, Left(ServerFailure('')));
  });

  test('should return server failure for recommendations', () async {
    when(mockRemoteDataSource.getTvSeriesRecommendations(100))
        .thenThrow(ServerException());
    final result = await repository.getTvSeriesRecommendations(100);
    expect(result, Left(ServerFailure('')));
  });

  test('should return connection failure for search tv series', () async {
    when(mockRemoteDataSource.searchTvSeries('demon slayer'))
        .thenThrow(const SocketException('Failed to connect to the network'));
    final result = await repository.searchTvSeries('demon slayer');
    expect(result, Left(ConnectionFailure('Failed to connect to the network')));
  });

  test('should return database failure when saving watchlist fails', () async {
    when(mockLocalDataSource.insertWatchlist(testTvSeriesTable))
        .thenThrow(DatabaseException('Failed to save'));
    final result = await repository.saveWatchlist(testTvSeriesDetail);
    expect(result, Left(DatabaseFailure('Failed to save')));
  });

  test('should return database failure when removing watchlist fails',
      () async {
    when(mockLocalDataSource.removeWatchlist(testTvSeriesTable))
        .thenThrow(DatabaseException('Failed to remove'));
    final result = await repository.removeWatchlist(testTvSeriesDetail);
    expect(result, Left(DatabaseFailure('Failed to remove')));
  });
}
