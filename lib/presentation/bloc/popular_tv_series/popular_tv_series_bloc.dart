import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'popular_tv_series_event.dart';
import 'popular_tv_series_state.dart';

class PopularTvSeriesBloc
    extends Bloc<PopularTvSeriesEvent, PopularTvSeriesState> {
  PopularTvSeriesBloc(this.getPopularTvSeries)
      : super(const PopularTvSeriesState()) {
    on<FetchPopularTvSeries>((event, emit) async {
      emit(state.copyWith(state: RequestState.Loading));

      final result = await getPopularTvSeries.execute();
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

  final GetPopularTvSeries getPopularTvSeries;
}
