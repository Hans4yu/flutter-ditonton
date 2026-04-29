import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'top_rated_tv_series_event.dart';
import 'top_rated_tv_series_state.dart';

class TopRatedTvSeriesBloc
    extends Bloc<TopRatedTvSeriesEvent, TopRatedTvSeriesState> {
  TopRatedTvSeriesBloc({required this.getTopRatedTvSeries})
      : super(const TopRatedTvSeriesState()) {
    on<FetchTopRatedTvSeries>((event, emit) async {
      emit(state.copyWith(state: RequestState.Loading));

      final result = await getTopRatedTvSeries.execute();
      result.fold(
        (failure) {
          emit(state.copyWith(
            state: RequestState.Error,
            message: failure.message,
          ));
        },
        (tvSeriesData) {
          emit(state.copyWith(
            state: RequestState.Loaded,
            tvSeries: tvSeriesData,
          ));
        },
      );
    });
  }

  final GetTopRatedTvSeries getTopRatedTvSeries;
}
