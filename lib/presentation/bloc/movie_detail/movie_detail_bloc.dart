import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'movie_detail_event.dart';
import 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const MovieDetailState()) {
    on<FetchMovieDetail>(_onFetchMovieDetail);
    on<LoadMovieWatchlistStatus>(_onLoadWatchlistStatus);
    on<AddMovieToWatchlist>(_onAddWatchlist);
    on<RemoveMovieFromWatchlist>(_onRemoveFromWatchlist);
  }

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  Future<void> _onFetchMovieDetail(
    FetchMovieDetail event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(state.copyWith(movieState: RequestState.Loading));
    final detailResult = await getMovieDetail.execute(event.id);
    final recommendationResult =
        await getMovieRecommendations.execute(event.id);

    detailResult.fold(
      (failure) {
        emit(state.copyWith(
          movieState: RequestState.Error,
          message: failure.message,
        ));
      },
      (movie) {
        emit(state.copyWith(
          movie: movie,
          recommendationState: RequestState.Loading,
        ));
        recommendationResult.fold(
          (failure) {
            emit(state.copyWith(
              movieState: RequestState.Loaded,
              recommendationState: RequestState.Error,
              message: failure.message,
            ));
          },
          (movies) {
            emit(state.copyWith(
              movieState: RequestState.Loaded,
              recommendationState: RequestState.Loaded,
              movieRecommendations: movies,
            ));
          },
        );
      },
    );
  }

  Future<void> _onLoadWatchlistStatus(
    LoadMovieWatchlistStatus event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await getWatchListStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }

  Future<void> _onAddWatchlist(
    AddMovieToWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await saveWatchlist.execute(event.movie);
    final message = result.fold(
      (failure) => failure.message,
      (successMessage) => successMessage,
    );
    final status = await getWatchListStatus.execute(event.movie.id);
    emit(state.copyWith(
      watchlistMessage: message,
      isAddedToWatchlist: status,
    ));
  }

  Future<void> _onRemoveFromWatchlist(
    RemoveMovieFromWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await removeWatchlist.execute(event.movie);
    final message = result.fold(
      (failure) => failure.message,
      (successMessage) => successMessage,
    );
    final status = await getWatchListStatus.execute(event.movie.id);
    emit(state.copyWith(
      watchlistMessage: message,
      isAddedToWatchlist: status,
    ));
  }
}
