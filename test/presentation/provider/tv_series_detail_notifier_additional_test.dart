import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:ditonton/presentation/provider/tv_series_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_notifier_additional_test.mocks.dart';

@GenerateMocks([
  GetTvSeriesDetail,
  GetTvSeriesRecommendations,
  GetWatchlistStatusTvSeries,
  SaveWatchlistTvSeries,
  RemoveWatchlistTvSeries,
])
void main() {
  late TvSeriesDetailNotifier provider;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late MockGetWatchlistStatusTvSeries mockGetWatchlistStatus;
  late MockSaveWatchlistTvSeries mockSaveWatchlist;
  late MockRemoveWatchlistTvSeries mockRemoveWatchlist;

  setUp(() {
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    mockGetWatchlistStatus = MockGetWatchlistStatusTvSeries();
    mockSaveWatchlist = MockSaveWatchlistTvSeries();
    mockRemoveWatchlist = MockRemoveWatchlistTvSeries();
    provider = TvSeriesDetailNotifier(
      getTvSeriesDetail: mockGetTvSeriesDetail,
      getTvSeriesRecommendations: mockGetTvSeriesRecommendations,
      getWatchlistStatusTvSeries: mockGetWatchlistStatus,
      saveWatchlistTvSeries: mockSaveWatchlist,
      removeWatchlistTvSeries: mockRemoveWatchlist,
    );
  });

  test('should return error when detail fetch is unsuccessful', () async {
    when(mockGetTvSeriesDetail.execute(100))
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    when(mockGetTvSeriesRecommendations.execute(100))
        .thenAnswer((_) async => Right(testTvSeriesList));

    await provider.fetchTvSeriesDetail(100);

    expect(provider.tvSeriesState, RequestState.Error);
    expect(provider.message, 'Server Failure');
  });

  test('should update recommendation error state', () async {
    when(mockGetTvSeriesDetail.execute(100))
        .thenAnswer((_) async => Right(testTvSeriesDetail));
    when(mockGetTvSeriesRecommendations.execute(100))
        .thenAnswer((_) async => Left(ServerFailure('Failed')));

    await provider.fetchTvSeriesDetail(100);

    expect(provider.recommendationState, RequestState.Error);
    expect(provider.message, 'Failed');
  });

  test('should execute save watchlist when function called', () async {
    when(mockSaveWatchlist.execute(testTvSeriesDetail))
        .thenAnswer((_) async => const Right('Added to Watchlist'));
    when(mockGetWatchlistStatus.execute(testTvSeriesDetail.id))
        .thenAnswer((_) async => true);

    await provider.addWatchlist(testTvSeriesDetail);

    verify(mockSaveWatchlist.execute(testTvSeriesDetail));
    expect(provider.isAddedToWatchlist, true);
  });

  test('should execute remove watchlist when function called', () async {
    when(mockRemoveWatchlist.execute(testTvSeriesDetail))
        .thenAnswer((_) async => const Right('Removed from Watchlist'));
    when(mockGetWatchlistStatus.execute(testTvSeriesDetail.id))
        .thenAnswer((_) async => false);

    await provider.removeFromWatchlist(testTvSeriesDetail);

    verify(mockRemoveWatchlist.execute(testTvSeriesDetail));
    expect(provider.isAddedToWatchlist, false);
  });
}
