import 'package:equatable/equatable.dart';

abstract class TvSeriesSearchEvent extends Equatable {
  const TvSeriesSearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchTvSeriesRequested extends TvSeriesSearchEvent {
  const SearchTvSeriesRequested(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}
