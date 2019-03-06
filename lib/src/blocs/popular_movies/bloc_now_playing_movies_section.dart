import 'package:meta/meta.dart';
import 'package:movieowski/src/blocs/base/bloc_event_state.dart';
import 'package:movieowski/src/blocs/popular_movies/bloc_now_playing_movies_section_event.dart';
import 'package:movieowski/src/blocs/popular_movies/bloc_now_playing_movies_section_state.dart';
import 'package:movieowski/src/models/now_playing_movies_response.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';
import 'package:movieowski/src/utils/consts.dart';

class NowPlayingMoviesSectionBloc
    extends BlocEventStateBase<NowPlayingMoviesSectionEvent, NowPlayingMoviesSectionState> {
  final MoviesRepository moviesRepository;

  NowPlayingMoviesSectionBloc({@required this.moviesRepository})
      : assert(moviesRepository != null),
        super(initialState: NowPlayingMoviesIsEmpty());

  @override
  Stream<NowPlayingMoviesSectionState> eventHandler(
      NowPlayingMoviesSectionEvent event, NowPlayingMoviesSectionState currentState) async* {
    if (event is FetchNowPlayingMovies) {
      yield NowPlayingMoviesIsLoading();
      try {
        final NowPlayingMoviesResponseRoot movies = await moviesRepository.fetchNowPlayingMovies(
            pageIndex: event.page,
            language: event.language,
            region: event.region);
        yield NowPlayingMoviesIsLoaded(movies.results);
      } catch (e, stacktrace) {
        Log.e(e, stacktrace);
        yield NowPlayingMoviesError();
      }
    }
  }
}
