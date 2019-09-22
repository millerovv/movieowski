import 'package:equatable/equatable.dart';
import 'package:movieowski/src/model/api/response/base_movies_response.dart';
import 'package:movieowski/src/model/api/response/movie_genres_response.dart';

abstract class MovieListState extends Equatable {
  MovieListState([List props = const []]) : super(props);
}

class MoviesEmpty extends MovieListState {}

class PagesLoaded extends MovieListState {
  final List<Movie> movies;
  final bool allPagesLoaded;
  final List<Genre> movieGenres;

  PagesLoaded(this.movies, this.allPagesLoaded, this.movieGenres) :
        assert(movies != null),
        assert(movieGenres != null),
        super([movies, allPagesLoaded]);
}

class MoviesLoadingError extends MovieListState {
  final String errorMessage;

  MoviesLoadingError(this.errorMessage) : super([errorMessage]);
}