import 'package:movieowski/src/blocs/base/bloc_event_state.dart';
import 'package:movieowski/src/blocs/home_page/bloc_now_playing_movies_section_event.dart';
import 'package:movieowski/src/blocs/home_page/bloc_now_playing_movies_section_state.dart';
import 'package:movieowski/src/models/trending_movies_response.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';
import 'package:movieowski/src/resources/api/base_api_provider.dart';
import 'package:movieowski/src/utils/logger.dart';

class TrendingMoviesSectionBloc extends BlocEventStateBase<MoviesSectionEvent, MoviesSectionState> {
	final String _sectionHeader = 'Trending';
	final bool _withSeeAllOption = false;
	final MoviesRepository _moviesRepository;

	String get sectionHeader => _sectionHeader;
	bool get withSeeAllOption => _withSeeAllOption;
	MoviesRepository get moviesRepository => _moviesRepository;

	TrendingMoviesSectionBloc(this._moviesRepository)
			: assert(_moviesRepository != null),
				super(initialState: MoviesIsEmpty());

	@override
	Stream<MoviesSectionState> eventHandler(
			MoviesSectionEvent event, MoviesSectionState currentState) async* {
		if (event is FetchMovies) {
			yield MoviesIsLoading();
			try {
				final TrendingMoviesResponseRoot movies = await _moviesRepository.fetchTrendingMovies();
				yield MoviesIsLoaded(movies.results);
			} on ApiRequestException catch (e, stacktrace) {
				Log.e(e, stacktrace);
				yield MoviesError(e.message);
			}
		}
	}

}
