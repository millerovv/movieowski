import 'package:equatable/equatable.dart';
import 'package:movieowski/src/model/api/response/base_movies_response.dart';

abstract class MoviesSectionState extends Equatable {
  MoviesSectionState([List props = const []]);
}

class MoviesIsEmpty extends MoviesSectionState {}

class MoviesIsLoading extends MoviesSectionState {}

class MoviesIsLoaded extends MoviesSectionState {
  final List<Movie> movies;
  final int maxPages;

  MoviesIsLoaded(this.movies, this.maxPages) :
        super([movies, maxPages]);
}

class MoviesError extends MoviesSectionState {
  final String errorMessage;

  MoviesError(this.errorMessage) : super([errorMessage]);
}