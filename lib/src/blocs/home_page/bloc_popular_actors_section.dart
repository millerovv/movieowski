import 'package:movieowski/src/blocs/base/bloc_event_state.dart';
import 'package:movieowski/src/blocs/home_page/bloc_popular_actors_section_event.dart';
import 'package:movieowski/src/blocs/home_page/bloc_popular_actors_section_state.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';
import 'package:movieowski/src/resources/api/base_api_provider.dart';
import 'package:movieowski/src/utils/logger.dart';

class PopularActorsSectionBloc extends BlocEventStateBase<PopularActorsSectionEvent, PopularActorsSectionState> {
	final MoviesRepository _moviesRepository;

	MoviesRepository get moviesRepository => _moviesRepository;

	PopularActorsSectionBloc(this._moviesRepository)
			: assert(_moviesRepository != null),
				super(initialState: PopularActorsIsEmpty());

	@override
	Stream<PopularActorsSectionState> eventHandler(
			PopularActorsSectionEvent event, PopularActorsSectionState currentState) async* {
		if (event is FetchPopularActors) {
			yield PopularActorsIsLoading();
			try {
				yield PopularActorsIsLoaded(await _moviesRepository.fetchPopularActorsWithDetails());
			} on ApiRequestException catch (e, stacktrace) {
				Log.e(e, stacktrace);
				yield PopularActorsError(e.message);
			}
		}
	}
}