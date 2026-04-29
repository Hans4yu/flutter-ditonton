import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'on_the_air_tv_series_event.dart';
import 'on_the_air_tv_series_state.dart';

class OnTheAirTvSeriesBloc
    extends Bloc<OnTheAirTvSeriesEvent, OnTheAirTvSeriesState> {
  OnTheAirTvSeriesBloc(this.getOnTheAirTvSeries)
      : super(const OnTheAirTvSeriesState()) {
    on<FetchOnTheAirTvSeries>((event, emit) async {
      emit(state.copyWith(state: RequestState.Loading));

      final result = await getOnTheAirTvSeries.execute();
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

  final GetOnTheAirTvSeries getOnTheAirTvSeries;
}
