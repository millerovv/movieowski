import 'package:meta/meta.dart';
import 'package:movieowski/src/blocs/base/bloc_event_state.dart';
import 'package:movieowski/src/blocs/popular_movies/bloc_popular_movies_event.dart';
import 'package:movieowski/src/blocs/popular_movies/bloc_popular_movies_state.dart';
import 'package:movieowski/src/models/popular_movie_model.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';

class PopularMoviesBloc extends BlocEventStateBase<PopularMoviesEvent, PopularMoviesState> {
  final MoviesRepository moviesRepository;

  PopularMoviesBloc({@required this.moviesRepository})
      : assert(moviesRepository != null),
        super(initialState: PopularMoviesState.notInitialized());

  @override
  Stream<PopularMoviesState> eventHandler(PopularMoviesEvent event, PopularMoviesState currentState) async* {
    if (event is FetchPopularMovies) {
      yield PopularMoviesState.loading();
      try {
        final PopularMoviesModel movies =
            await moviesRepository.fetchPopularMovies(
                pageIndex: event.page,
                language: event.language,
                region: event.region);
        yield PopularMoviesState.loaded(movies);
      } catch (_) {
        yield PopularMoviesState.error();
      }
    }
  }
}
