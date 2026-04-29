import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'tv_series_detail_event.dart';
import 'tv_series_detail_state.dart';

class TvSeriesDetailBloc
    extends Bloc<TvSeriesDetailEvent, TvSeriesDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  TvSeriesDetailBloc({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
    required this.getWatchlistStatusTvSeries,
    required this.saveWatchlistTvSeries,
    required this.removeWatchlistTvSeries,
  }) : super(const TvSeriesDetailState()) {
    on<FetchTvSeriesDetail>(_onFetchTvSeriesDetail);
    on<LoadTvSeriesWatchlistStatus>(_onLoadWatchlistStatus);
    on<AddTvSeriesToWatchlist>(_onAddWatchlist);
    on<RemoveTvSeriesFromWatchlist>(_onRemoveFromWatchlist);
  }

  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final GetWatchlistStatusTvSeries getWatchlistStatusTvSeries;
  final SaveWatchlistTvSeries saveWatchlistTvSeries;
  final RemoveWatchlistTvSeries removeWatchlistTvSeries;

  Future<void> _onFetchTvSeriesDetail(
    FetchTvSeriesDetail event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    emit(state.copyWith(tvSeriesState: RequestState.Loading));
    final detailResult = await getTvSeriesDetail.execute(event.id);
    final recommendationResult =
        await getTvSeriesRecommendations.execute(event.id);

    detailResult.fold(
      (failure) {
        emit(state.copyWith(
          tvSeriesState: RequestState.Error,
          message: failure.message,
        ));
      },
      (tvSeries) {
        emit(state.copyWith(
          tvSeries: tvSeries,
          recommendationState: RequestState.Loading,
        ));
        recommendationResult.fold(
          (failure) {
            emit(state.copyWith(
              tvSeriesState: RequestState.Loaded,
              recommendationState: RequestState.Error,
              message: failure.message,
            ));
          },
          (recommendations) {
            emit(state.copyWith(
              tvSeriesState: RequestState.Loaded,
              recommendationState: RequestState.Loaded,
              tvSeriesRecommendations: recommendations,
            ));
          },
        );
      },
    );
  }

  Future<void> _onLoadWatchlistStatus(
    LoadTvSeriesWatchlistStatus event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final result = await getWatchlistStatusTvSeries.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }

  Future<void> _onAddWatchlist(
    AddTvSeriesToWatchlist event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final result = await saveWatchlistTvSeries.execute(event.tvSeries);
    final message = result.fold(
      (failure) => failure.message,
      (successMessage) => successMessage,
    );
    final status = await getWatchlistStatusTvSeries.execute(event.tvSeries.id);
    emit(state.copyWith(
      watchlistMessage: message,
      isAddedToWatchlist: status,
    ));
  }

  Future<void> _onRemoveFromWatchlist(
    RemoveTvSeriesFromWatchlist event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final result = await removeWatchlistTvSeries.execute(event.tvSeries);
    final message = result.fold(
      (failure) => failure.message,
      (successMessage) => successMessage,
    );
    final status = await getWatchlistStatusTvSeries.execute(event.tvSeries.id);
    emit(state.copyWith(
      watchlistMessage: message,
      isAddedToWatchlist: status,
    ));
  }
}
