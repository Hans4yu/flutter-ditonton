import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'top_rated_movies_event.dart';
import 'top_rated_movies_state.dart';

class TopRatedMoviesBloc
    extends Bloc<TopRatedMoviesEvent, TopRatedMoviesState> {
  TopRatedMoviesBloc({required this.getTopRatedMovies})
      : super(const TopRatedMoviesState()) {
    on<FetchTopRatedMovies>((event, emit) async {
      emit(state.copyWith(state: RequestState.Loading));

      final result = await getTopRatedMovies.execute();
      result.fold(
        (failure) {
          emit(state.copyWith(
            state: RequestState.Error,
            message: failure.message,
          ));
        },
        (moviesData) {
          emit(state.copyWith(
            state: RequestState.Loaded,
            movies: moviesData,
          ));
        },
      );
    });
  }

  final GetTopRatedMovies getTopRatedMovies;
}
