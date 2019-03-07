import 'package:movieowski/src/blocs/base/bloc_event_state.dart';
import 'package:movieowski/src/blocs/home_page/bloc_now_playing_movies_section_event.dart';
import 'package:movieowski/src/blocs/home_page/bloc_now_playing_movies_section_state.dart';
import 'package:movieowski/src/models/now_playing_movies_response.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';
import 'package:movieowski/src/resources/api/base_api_provider.dart';
import 'package:movieowski/src/utils/logger.dart';

class NowPlayingMoviesSectionBloc extends BlocEventStateBase<MoviesSectionEvent, MoviesSectionState> {
  final String _sectionHeader = 'In theaters';
  final bool _withSeeAllOption = true;
  final MoviesRepository _moviesRepository;

  String get sectionHeader => _sectionHeader;
  bool get withSeeAllOption => _withSeeAllOption;
  MoviesRepository get moviesRepository => _moviesRepository;

  NowPlayingMoviesSectionBloc(this._moviesRepository)
      : assert(_moviesRepository != null),
        super(initialState: MoviesIsEmpty());

  @override
  Stream<MoviesSectionState> eventHandler(
      MoviesSectionEvent event, MoviesSectionState currentState) async* {
    if (event is FetchMovies) {
      yield MoviesIsLoading();
      try {
        final NowPlayingMoviesResponseRoot movies = await _moviesRepository.fetchNowPlayingMovies(
            pageIndex: event.page,
            language: event.language,
            region: event.region);
        yield MoviesIsLoaded(movies.results);
      } on ApiRequestException catch (e, stacktrace) {
        Log.e(e, stacktrace);
        yield MoviesError(e.message);
      } 
    }
  }

}
