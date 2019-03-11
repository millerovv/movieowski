import 'package:movieowski/src/blocs/home_page/actors/bloc_popular_actors_section_event.dart';
import 'package:movieowski/src/blocs/home_page/actors/bloc_popular_actors_section_state.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';
import 'package:movieowski/src/resources/api/base_api_provider.dart';
import 'package:movieowski/src/utils/logger.dart';
import 'package:bloc/bloc.dart';

class PopularActorsSectionBloc extends Bloc<PopularActorsSectionEvent, PopularActorsSectionState> {
  final MoviesRepository _moviesRepository;

  MoviesRepository get moviesRepository => _moviesRepository;

  PopularActorsSectionBloc(this._moviesRepository) : assert(_moviesRepository != null);

  @override
  PopularActorsSectionState get initialState => PopularActorsIsEmpty();

  @override
  Stream<PopularActorsSectionState> mapEventToState(
      PopularActorsSectionState currentState, PopularActorsSectionEvent event) async* {
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
