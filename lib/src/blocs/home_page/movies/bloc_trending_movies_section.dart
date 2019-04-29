import 'package:movieowski/src/blocs/home_page/movies/bloc_movies_section.dart';
import 'package:movieowski/src/blocs/home_page/movies/bloc_movies_section_event.dart';
import 'package:movieowski/src/blocs/home_page/movies/bloc_movies_section_state.dart';
import 'package:movieowski/src/model/api/response/trending_movies_response.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';
import 'package:movieowski/src/resources/api/base_api_provider.dart';
import 'package:movieowski/src/utils/logger.dart';

class TrendingMoviesSectionBloc extends MoviesSectionBloc {
	final String _sectionHeader = 'Trending';
	final bool _withSeeAllOption = false;
	final MoviesRepository _moviesRepository;

	String get sectionHeader => _sectionHeader;
	bool get withSeeAllOption => _withSeeAllOption;

	TrendingMoviesSectionBloc(this._moviesRepository)
			: assert(_moviesRepository != null),
				super(_moviesRepository);

	@override
	Stream<MoviesSectionState> mapEventToState(MoviesSectionState currentState, MoviesSectionEvent event) async* {
		if (event is FetchMovies) {
			yield MoviesIsLoading();
			try {
				final TrendingMoviesResponseRoot movies = await _moviesRepository.fetchTrendingMovies();
				yield MoviesIsLoaded(movies.results, movies.totalPages);
			} on ApiRequestException catch (e, stacktrace) {
				Log.e(e, stacktrace);
				yield MoviesError(e.message);
			}
		}
	}
}
