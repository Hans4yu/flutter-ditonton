import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:equatable/equatable.dart';

class TvSeriesListState extends Equatable {
  const TvSeriesListState({
    this.onTheAirTvSeries = const [],
    this.onTheAirState = RequestState.Empty,
    this.popularTvSeries = const [],
    this.popularTvSeriesState = RequestState.Empty,
    this.topRatedTvSeries = const [],
    this.topRatedTvSeriesState = RequestState.Empty,
    this.message = '',
  });

  final List<TvSeries> onTheAirTvSeries;
  final RequestState onTheAirState;
  final List<TvSeries> popularTvSeries;
  final RequestState popularTvSeriesState;
  final List<TvSeries> topRatedTvSeries;
  final RequestState topRatedTvSeriesState;
  final String message;

  TvSeriesListState copyWith({
    List<TvSeries>? onTheAirTvSeries,
    RequestState? onTheAirState,
    List<TvSeries>? popularTvSeries,
    RequestState? popularTvSeriesState,
    List<TvSeries>? topRatedTvSeries,
    RequestState? topRatedTvSeriesState,
    String? message,
  }) {
    return TvSeriesListState(
      onTheAirTvSeries: onTheAirTvSeries ?? this.onTheAirTvSeries,
      onTheAirState: onTheAirState ?? this.onTheAirState,
      popularTvSeries: popularTvSeries ?? this.popularTvSeries,
      popularTvSeriesState: popularTvSeriesState ?? this.popularTvSeriesState,
      topRatedTvSeries: topRatedTvSeries ?? this.topRatedTvSeries,
      topRatedTvSeriesState:
          topRatedTvSeriesState ?? this.topRatedTvSeriesState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        onTheAirTvSeries,
        onTheAirState,
        popularTvSeries,
        popularTvSeriesState,
        topRatedTvSeries,
        topRatedTvSeriesState,
        message,
      ];
}
