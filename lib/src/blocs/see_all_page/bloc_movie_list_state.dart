import 'package:equatable/equatable.dart';
import 'package:movieowski/src/model/api/response/base_movies_response.dart';

abstract class MovieListState extends Equatable {
  MovieListState([List props = const []]) : super(props);
}

class MoviesEmpty extends MovieListState {}

class PagesLoaded extends MovieListState {
  final List<Movie> movies;
  final bool allPagesLoaded;

  PagesLoaded(this.movies, this.allPagesLoaded) :
        assert(movies != null),
        super([movies, allPagesLoaded]);
}

class MoviesLoadingError extends MovieListState {
  final String errorMessage;

  MoviesLoadingError(this.errorMessage) : super([errorMessage]);
}