import 'package:equatable/equatable.dart';
import 'package:movieowski/src/blocs/base/bloc_event_state.dart';
import 'package:movieowski/src/models/base_movies_response.dart';

abstract class MoviesSectionState extends Equatable implements BlocState {
  MoviesSectionState([List props = const []]);
}

class MoviesIsEmpty extends MoviesSectionState {}

class MoviesIsLoading extends MoviesSectionState {}

class MoviesIsLoaded extends MoviesSectionState {
  final List<BaseResponseMovie> movies;

  MoviesIsLoaded(this.movies) :
        assert(movies != null),
        super(movies);
}

class MoviesError extends MoviesSectionState {
  final String errorMessage;

  MoviesError(this.errorMessage) : super([errorMessage]);
}