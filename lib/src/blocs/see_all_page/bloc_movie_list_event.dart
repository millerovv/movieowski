import 'package:equatable/equatable.dart';
import 'package:movieowski/src/model/api/response/movie_genres_response.dart';

abstract class MovieListEvent extends Equatable {
	MovieListEvent([List props = const []]) : super(props);
}

/// [index] of [MovieListCard] info for which needs to be fetched
class FetchMovies extends MovieListEvent {
	FetchMovies({this.genres = const <Genre>[]}) :
				super([genres]);

	final List<Genre> genres;
}

class FetchMoviesWithReset extends FetchMovies {
	FetchMoviesWithReset({this.genres = const <Genre>[]}) :
				super(genres: genres);

	final List<Genre> genres;
}