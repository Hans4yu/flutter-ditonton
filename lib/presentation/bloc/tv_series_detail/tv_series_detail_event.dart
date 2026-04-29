import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:equatable/equatable.dart';

abstract class TvSeriesDetailEvent extends Equatable {
  const TvSeriesDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchTvSeriesDetail extends TvSeriesDetailEvent {
  const FetchTvSeriesDetail(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

class LoadTvSeriesWatchlistStatus extends TvSeriesDetailEvent {
  const LoadTvSeriesWatchlistStatus(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

class AddTvSeriesToWatchlist extends TvSeriesDetailEvent {
  const AddTvSeriesToWatchlist(this.tvSeries);

  final TvSeriesDetail tvSeries;

  @override
  List<Object?> get props => [tvSeries];
}

class RemoveTvSeriesFromWatchlist extends TvSeriesDetailEvent {
  const RemoveTvSeriesFromWatchlist(this.tvSeries);

  final TvSeriesDetail tvSeries;

  @override
  List<Object?> get props => [tvSeries];
}
