import 'package:bloc/bloc.dart';
import 'package:movieowski/src/blocs/home_page/genres/bloc_movie_genres_section_event.dart';
import 'package:movieowski/src/blocs/home_page/genres/bloc_movie_genres_section_state.dart';
import 'package:movieowski/src/model/api/response/movie_genres_response.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';
import 'package:movieowski/src/resources/api/base_api_provider.dart';
import 'package:movieowski/src/utils/logger.dart';

class MovieGenresSectionBloc extends Bloc<MovieGenresSectionEvent, MovieGenresSectionState> {
  final MoviesRepository _moviesRepository;

  MoviesRepository get moviesRepository => _moviesRepository;

  MovieGenresSectionBloc(this._moviesRepository) : assert(_moviesRepository != null);

  @override
  MovieGenresSectionState get initialState => MovieGenresIsEmpty();

  @override
  Stream<MovieGenresSectionState> mapEventToState(
      MovieGenresSectionState currentState, MovieGenresSectionEvent event) async* {
    if (event is FetchGenres) {
      yield MovieGenresIsLoading();
      try {
        List<Genre> genres = await _moviesRepository.fetchMovieGenres();
        yield MovieGenresIsLoaded(genres);
      } on ApiRequestException catch (e, stacktrace) {
        Log.e(e, stacktrace);
        if (e is ApiRequestFailedException) {
          Log.e(e, e.apiResponse);
        }
        yield MovieGenresError(e.message);
      }
    }
  }
}
