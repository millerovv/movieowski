import 'package:bloc/bloc.dart';
import 'package:movieowski/src/blocs/query_search_results/bloc_query_search_results_event.dart';
import 'package:movieowski/src/blocs/query_search_results/bloc_query_search_results_state.dart';
import 'package:movieowski/src/model/api/response/movie_genres_response.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';
import 'package:movieowski/src/resources/api/base_api_provider.dart';
import 'package:movieowski/src/utils/logger.dart';

class QuerySearchResultsBloc extends Bloc<QuerySearchResultsEvent, QuerySearchResultsState> {
	final MoviesRepository _moviesRepository;

	QuerySearchResultsBloc(this._moviesRepository) : assert(_moviesRepository != null);

	@override
	QuerySearchResultsState get initialState => MovieGenresIsEmpty();

	@override
	Stream<QuerySearchResultsState> mapEventToState(
			QuerySearchResultsState currentState, QuerySearchResultsEvent event) async* {
		if (event is FetchMovieGenres) {
			yield MovieGenresIsLoading();
			try {
				List<Genre> genres = await _moviesRepository.fetchMovieGenres();
				yield MovieGenresIsLoaded(genres);
			} on ApiRequestException catch (e, stacktrace) {
				Log.e(e, stacktrace);
				if (e is ApiRequestFailedException) {
					Log.e(e, e.apiResponse);
				}
				yield MovieGenresLoadingError(e.message);
			}
		}
	}
}
