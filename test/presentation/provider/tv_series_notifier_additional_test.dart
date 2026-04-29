import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/provider/popular_tv_series_notifier.dart';
import 'package:ditonton/presentation/provider/tv_series_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_notifier_additional_test.mocks.dart';

@GenerateMocks([GetOnTheAirTvSeries, GetPopularTvSeries, GetTopRatedTvSeries])
void main() {
  test(
      'popular tv series notifier should return error when data is unsuccessful',
      () async {
    final mockUsecase = MockGetPopularTvSeries();
    final provider = PopularTvSeriesNotifier(mockUsecase);

    when(mockUsecase.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

    await provider.fetchPopularTvSeries();

    expect(provider.state, RequestState.Error);
    expect(provider.message, 'Server Failure');
  });

  test(
      'tv series list notifier should return popular error when data is unsuccessful',
      () async {
    final provider = TvSeriesListNotifier(
      getOnTheAirTvSeries: MockGetOnTheAirTvSeries(),
      getPopularTvSeries: MockGetPopularTvSeries(),
      getTopRatedTvSeries: MockGetTopRatedTvSeries(),
    );
    final popularUsecase =
        provider.getPopularTvSeries as MockGetPopularTvSeries;

    when(popularUsecase.execute())
        .thenAnswer((_) async => Left(ServerFailure('Popular Failure')));

    await provider.fetchPopularTvSeries();

    expect(provider.popularTvSeriesState, RequestState.Error);
    expect(provider.message, 'Popular Failure');
  });

  test(
      'tv series list notifier should return top rated error when data is unsuccessful',
      () async {
    final provider = TvSeriesListNotifier(
      getOnTheAirTvSeries: MockGetOnTheAirTvSeries(),
      getPopularTvSeries: MockGetPopularTvSeries(),
      getTopRatedTvSeries: MockGetTopRatedTvSeries(),
    );
    final topRatedUsecase =
        provider.getTopRatedTvSeries as MockGetTopRatedTvSeries;

    when(topRatedUsecase.execute())
        .thenAnswer((_) async => Left(ServerFailure('Top Rated Failure')));

    await provider.fetchTopRatedTvSeries();

    expect(provider.topRatedTvSeriesState, RequestState.Error);
    expect(provider.message, 'Top Rated Failure');
  });

  test(
      'tv series list notifier should change on the air state to loading immediately',
      () {
    final onTheAir = MockGetOnTheAirTvSeries();
    final provider = TvSeriesListNotifier(
      getOnTheAirTvSeries: onTheAir,
      getPopularTvSeries: MockGetPopularTvSeries(),
      getTopRatedTvSeries: MockGetTopRatedTvSeries(),
    );

    when(onTheAir.execute()).thenAnswer((_) async => Right(testTvSeriesList));
    provider.fetchOnTheAirTvSeries();

    expect(provider.onTheAirState, RequestState.Loading);
  });
}
