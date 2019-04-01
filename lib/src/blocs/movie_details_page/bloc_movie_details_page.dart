import 'package:bloc/bloc.dart';
import 'package:movieowski/src/blocs/movie_details_page/bloc_movie_details_page_event.dart';
import 'package:movieowski/src/blocs/movie_details_page/bloc_movie_details_page_state.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';

class MovieDetailsPageBloc extends Bloc<MovieDetailsPageEvent, MovieDetailsPageState> {

	final MoviesRepository _moviesRepository;

	MoviesRepository get moviesRepository => _moviesRepository;

	MovieDetailsPageBloc(this._moviesRepository) : assert(_moviesRepository != null);

	@override
	MovieDetailsPageState get initialState {
		//TODO: implement this method
	}

	@override
	Stream<MovieDetailsPageState> mapEventToState(MovieDetailsPageState currentState, MovieDetailsPageEvent event) {
		//TODO: implement this method
	}
}