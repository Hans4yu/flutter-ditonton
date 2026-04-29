import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchMovieDetail extends MovieDetailEvent {
  const FetchMovieDetail(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

class LoadMovieWatchlistStatus extends MovieDetailEvent {
  const LoadMovieWatchlistStatus(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

class AddMovieToWatchlist extends MovieDetailEvent {
  const AddMovieToWatchlist(this.movie);

  final MovieDetail movie;

  @override
  List<Object?> get props => [movie];
}

class RemoveMovieFromWatchlist extends MovieDetailEvent {
  const RemoveMovieFromWatchlist(this.movie);

  final MovieDetail movie;

  @override
  List<Object?> get props => [movie];
}
