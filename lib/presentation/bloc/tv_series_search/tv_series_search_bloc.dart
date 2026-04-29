import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'tv_series_search_event.dart';
import 'tv_series_search_state.dart';

class TvSeriesSearchBloc
    extends Bloc<TvSeriesSearchEvent, TvSeriesSearchState> {
  TvSeriesSearchBloc({required this.searchTvSeries})
      : super(const TvSeriesSearchState()) {
    on<SearchTvSeriesRequested>((event, emit) async {
      emit(state.copyWith(state: RequestState.Loading));

      final result = await searchTvSeries.execute(event.query);
      result.fold(
        (failure) {
          emit(state.copyWith(
            state: RequestState.Error,
            message: failure.message,
          ));
        },
        (data) {
          emit(state.copyWith(
            state: RequestState.Loaded,
            searchResult: data,
          ));
        },
      );
    });
  }

  final SearchTvSeries searchTvSeries;
}
