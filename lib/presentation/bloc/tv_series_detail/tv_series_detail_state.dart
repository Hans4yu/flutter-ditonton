import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:equatable/equatable.dart';

class TvSeriesDetailState extends Equatable {
  const TvSeriesDetailState({
    this.tvSeries,
    this.tvSeriesState = RequestState.Empty,
    this.tvSeriesRecommendations = const [],
    this.recommendationState = RequestState.Empty,
    this.message = '',
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
  });

  final TvSeriesDetail? tvSeries;
  final RequestState tvSeriesState;
  final List<TvSeries> tvSeriesRecommendations;
  final RequestState recommendationState;
  final String message;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  TvSeriesDetailState copyWith({
    TvSeriesDetail? tvSeries,
    RequestState? tvSeriesState,
    List<TvSeries>? tvSeriesRecommendations,
    RequestState? recommendationState,
    String? message,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return TvSeriesDetailState(
      tvSeries: tvSeries ?? this.tvSeries,
      tvSeriesState: tvSeriesState ?? this.tvSeriesState,
      tvSeriesRecommendations:
          tvSeriesRecommendations ?? this.tvSeriesRecommendations,
      recommendationState: recommendationState ?? this.recommendationState,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
        tvSeries,
        tvSeriesState,
        tvSeriesRecommendations,
        recommendationState,
        message,
        isAddedToWatchlist,
        watchlistMessage,
      ];
}
