import 'package:equatable/equatable.dart';
import 'package:movieowski/src/model/api/response/movie_genres_response.dart';

abstract class QuerySearchResultsState extends Equatable {
	QuerySearchResultsState([List props = const []]);
}

class MovieGenresIsEmpty extends QuerySearchResultsState {}

class MovieGenresIsLoading extends QuerySearchResultsState {}

class MovieGenresIsLoaded extends QuerySearchResultsState {
	final List<Genre> genres;

	MovieGenresIsLoaded(this.genres) :
				assert(genres != null),
				super([genres]);
}

class MovieGenresLoadingError extends QuerySearchResultsState {
	final String errorMessage;

	MovieGenresLoadingError(this.errorMessage) : super([errorMessage]);
}