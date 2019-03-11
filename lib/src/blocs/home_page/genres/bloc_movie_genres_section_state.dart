import 'package:equatable/equatable.dart';
import 'package:movieowski/src/model/api/response/movie_genres_response.dart';

abstract class MovieGenresSectionState extends Equatable {
	MovieGenresSectionState([List props = const []]);
}

class MovieGenresIsEmpty extends MovieGenresSectionState {}

class MovieGenresIsLoading extends MovieGenresSectionState {}

class MovieGenresIsLoaded extends MovieGenresSectionState {
	final List<Genre> genres;

	MovieGenresIsLoaded(this.genres) :
				assert(genres != null),
				super(genres);
}

class MovieGenresError extends MovieGenresSectionState {
	final String errorMessage;

	MovieGenresError(this.errorMessage) : super([errorMessage]);
}