import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

class WatchlistMovieState extends Equatable {
  const WatchlistMovieState({
    this.watchlistState = RequestState.Empty,
    this.watchlistMovies = const [],
    this.message = '',
  });

  final RequestState watchlistState;
  final List<Movie> watchlistMovies;
  final String message;

  WatchlistMovieState copyWith({
    RequestState? watchlistState,
    List<Movie>? watchlistMovies,
    String? message,
  }) {
    return WatchlistMovieState(
      watchlistState: watchlistState ?? this.watchlistState,
      watchlistMovies: watchlistMovies ?? this.watchlistMovies,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [watchlistState, watchlistMovies, message];
}
