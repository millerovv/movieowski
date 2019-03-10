import 'package:bloc/bloc.dart';
import 'package:movieowski/src/blocs/home_page/genres/bloc_movie_genres_section_event.dart';
import 'package:movieowski/src/blocs/home_page/genres/bloc_movie_genres_section_state.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';

class MovieGenresSectionBloc extends Bloc<MovieGenresSectionEvent, MovieGenresSectionState> {
	final MoviesRepository _moviesRepository;

	MoviesRepository get moviesRepository => _moviesRepository;

	MovieGenresSectionBloc(this._moviesRepository)
			: assert(_moviesRepository != null);

	@override
	MovieGenresSectionState get initialState => MovieGenresIsEmpty();

	@override
	Stream<MovieGenresSectionState> mapEventToState(MovieGenresSectionState currentState, MovieGenresSectionEvent event) {

	}
}