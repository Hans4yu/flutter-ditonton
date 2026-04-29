import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

class MovieSearchState extends Equatable {
  const MovieSearchState({
    this.state = RequestState.Empty,
    this.searchResult = const [],
    this.message = '',
  });

  final RequestState state;
  final List<Movie> searchResult;
  final String message;

  MovieSearchState copyWith({
    RequestState? state,
    List<Movie>? searchResult,
    String? message,
  }) {
    return MovieSearchState(
      state: state ?? this.state,
      searchResult: searchResult ?? this.searchResult,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, searchResult, message];
}
