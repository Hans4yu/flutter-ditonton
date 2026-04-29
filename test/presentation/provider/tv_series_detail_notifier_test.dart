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
import 'tv_series_detail_notifier_test.mocks.dart';

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

  const tId = 100;

  void arrangeUsecase() {
    when(mockGetTvSeriesDetail.execute(tId))
        .thenAnswer((_) async => Right(testTvSeriesDetail));
    when(mockGetTvSeriesRecommendations.execute(tId))
        .thenAnswer((_) async => Right(testTvSeriesList));
  }

  test('should get tv series detail from the usecases', () async {
    arrangeUsecase();
    await provider.fetchTvSeriesDetail(tId);
    verify(mockGetTvSeriesDetail.execute(tId));
    verify(mockGetTvSeriesRecommendations.execute(tId));
    expect(provider.tvSeries, testTvSeriesDetail);
    expect(provider.tvSeriesRecommendations, testTvSeriesList);
  });

  test('should update recommendation state when data is gotten successfully',
      () async {
    arrangeUsecase();
    await provider.fetchTvSeriesDetail(tId);
    expect(provider.recommendationState, RequestState.Loaded);
  });

  test('should get the watchlist status', () async {
    when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
    await provider.loadWatchlistStatus(tId);
    expect(provider.isAddedToWatchlist, true);
  });

  test('should update watchlist message when add watchlist failed', () async {
    when(mockSaveWatchlist.execute(testTvSeriesDetail))
        .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
    when(mockGetWatchlistStatus.execute(testTvSeriesDetail.id))
        .thenAnswer((_) async => false);
    await provider.addWatchlist(testTvSeriesDetail);
    expect(provider.watchlistMessage, 'Failed');
  });
}
