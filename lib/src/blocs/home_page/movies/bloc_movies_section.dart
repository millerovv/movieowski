import 'package:bloc/bloc.dart';
import 'package:movieowski/src/blocs/home_page/movies/bloc_movies_section_event.dart';
import 'package:movieowski/src/blocs/home_page/movies/bloc_movies_section_state.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';

abstract class MoviesSectionBloc extends Bloc<MoviesSectionEvent, MoviesSectionState> {
	String _sectionHeader;
	bool _withSeeAllOption;
	MoviesRepository _moviesRepository;

	String get sectionHeader => _sectionHeader;
	bool get withSeeAllOption => _withSeeAllOption;
	MoviesRepository get moviesRepository => _moviesRepository;


	@override
	MoviesSectionState get initialState => MoviesIsEmpty();

	MoviesSectionBloc(this._moviesRepository) :
				assert(_moviesRepository != null);
}