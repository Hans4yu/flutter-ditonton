import 'package:equatable/equatable.dart';

abstract class MovieSearchEvent extends Equatable {
  const MovieSearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchMoviesRequested extends MovieSearchEvent {
  const SearchMoviesRequested(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}
