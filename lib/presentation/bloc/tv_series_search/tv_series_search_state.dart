import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:equatable/equatable.dart';

class TvSeriesSearchState extends Equatable {
  const TvSeriesSearchState({
    this.state = RequestState.Empty,
    this.searchResult = const [],
    this.message = '',
  });

  final RequestState state;
  final List<TvSeries> searchResult;
  final String message;

  TvSeriesSearchState copyWith({
    RequestState? state,
    List<TvSeries>? searchResult,
    String? message,
  }) {
    return TvSeriesSearchState(
      state: state ?? this.state,
      searchResult: searchResult ?? this.searchResult,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, searchResult, message];
}
