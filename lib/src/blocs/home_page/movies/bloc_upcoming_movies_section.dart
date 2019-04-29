import 'package:movieowski/src/blocs/home_page/movies/bloc_movies_section.dart';
import 'package:movieowski/src/blocs/home_page/movies/bloc_movies_section_event.dart';
import 'package:movieowski/src/blocs/home_page/movies/bloc_movies_section_state.dart';
import 'package:movieowski/src/model/api/response/upcoming_movies_response.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';
import 'package:movieowski/src/resources/api/base_api_provider.dart';
import 'package:movieowski/src/utils/logger.dart';

class UpcomingMoviesSectionBloc extends MoviesSectionBloc {
	final String _sectionHeader = 'Upcoming';
	final bool _withSeeAllOption = true;
	final MoviesRepository _moviesRepository;

	String get sectionHeader => _sectionHeader;
	bool get withSeeAllOption => _withSeeAllOption;

	UpcomingMoviesSectionBloc(this._moviesRepository)
			: assert(_moviesRepository != null),
				super(_moviesRepository);

	@override
	Stream<MoviesSectionState> mapEventToState(MoviesSectionState currentState, MoviesSectionEvent event) async* {
		if (event is FetchMovies) {
			yield MoviesIsLoading();
			try {
				final UpcomingMoviesResponseRoot movies = await _moviesRepository.fetchUpcomingMovies();
				yield MoviesIsLoaded(movies.results, movies.totalPages);
			} on ApiRequestException catch (e, stacktrace) {
				Log.e(e, stacktrace);
				yield MoviesError(e.message);
			}
		}
	}
}