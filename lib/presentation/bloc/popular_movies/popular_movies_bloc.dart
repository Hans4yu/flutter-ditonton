import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'popular_movies_event.dart';
import 'popular_movies_state.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  PopularMoviesBloc(this.getPopularMovies) : super(const PopularMoviesState()) {
    on<FetchPopularMovies>((event, emit) async {
      emit(state.copyWith(state: RequestState.Loading));

      final result = await getPopularMovies.execute();
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

  final GetPopularMovies getPopularMovies;
}
