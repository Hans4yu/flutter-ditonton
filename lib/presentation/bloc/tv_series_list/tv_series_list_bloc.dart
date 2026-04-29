import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'tv_series_list_event.dart';
import 'tv_series_list_state.dart';

class TvSeriesListBloc extends Bloc<TvSeriesListEvent, TvSeriesListState> {
  TvSeriesListBloc({
    required this.getOnTheAirTvSeries,
    required this.getPopularTvSeries,
    required this.getTopRatedTvSeries,
  }) : super(const TvSeriesListState()) {
    on<FetchOnTheAirTvSeries>(_onFetchOnTheAirTvSeries);
    on<FetchPopularTvSeries>(_onFetchPopularTvSeries);
    on<FetchTopRatedTvSeries>(_onFetchTopRatedTvSeries);
  }

  final GetOnTheAirTvSeries getOnTheAirTvSeries;
  final GetPopularTvSeries getPopularTvSeries;
  final GetTopRatedTvSeries getTopRatedTvSeries;

  Future<void> _onFetchOnTheAirTvSeries(
    FetchOnTheAirTvSeries event,
    Emitter<TvSeriesListState> emit,
  ) async {
    emit(state.copyWith(onTheAirState: RequestState.Loading));
    final result = await getOnTheAirTvSeries.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        onTheAirState: RequestState.Error,
        message: failure.message,
      )),
      (tvSeriesData) => emit(state.copyWith(
        onTheAirState: RequestState.Loaded,
        onTheAirTvSeries: tvSeriesData,
      )),
    );
  }

  Future<void> _onFetchPopularTvSeries(
    FetchPopularTvSeries event,
    Emitter<TvSeriesListState> emit,
  ) async {
    emit(state.copyWith(popularTvSeriesState: RequestState.Loading));
    final result = await getPopularTvSeries.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        popularTvSeriesState: RequestState.Error,
        message: failure.message,
      )),
      (tvSeriesData) => emit(state.copyWith(
        popularTvSeriesState: RequestState.Loaded,
        popularTvSeries: tvSeriesData,
      )),
    );
  }

  Future<void> _onFetchTopRatedTvSeries(
    FetchTopRatedTvSeries event,
    Emitter<TvSeriesListState> emit,
  ) async {
    emit(state.copyWith(topRatedTvSeriesState: RequestState.Loading));
    final result = await getTopRatedTvSeries.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        topRatedTvSeriesState: RequestState.Error,
        message: failure.message,
      )),
      (tvSeriesData) => emit(state.copyWith(
        topRatedTvSeriesState: RequestState.Loaded,
        topRatedTvSeries: tvSeriesData,
      )),
    );
  }
}
