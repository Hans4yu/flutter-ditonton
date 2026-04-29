import 'package:equatable/equatable.dart';

abstract class TvSeriesListEvent extends Equatable {
  const TvSeriesListEvent();

  @override
  List<Object?> get props => [];
}

class FetchOnTheAirTvSeries extends TvSeriesListEvent {
  const FetchOnTheAirTvSeries();
}

class FetchPopularTvSeries extends TvSeriesListEvent {
  const FetchPopularTvSeries();
}

class FetchTopRatedTvSeries extends TvSeriesListEvent {
  const FetchTopRatedTvSeries();
}
