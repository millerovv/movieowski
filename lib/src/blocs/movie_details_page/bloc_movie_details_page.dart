import 'package:bloc/bloc.dart';
import 'package:movieowski/src/blocs/movie_details_page/bloc_movie_details_page_event.dart';
import 'package:movieowski/src/blocs/movie_details_page/bloc_movie_details_page_state.dart';
import 'package:movieowski/src/model/api/response/movie_details_with_credits_response.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';
import 'package:movieowski/src/resources/api/base_api_provider.dart';
import 'package:movieowski/src/utils/logger.dart';

class MovieDetailsPageBloc extends Bloc<MovieDetailsPageEvent, MovieDetailsPageState> {
  final MoviesRepository _moviesRepository;
  final int _movieId;

  MoviesRepository get moviesRepository => _moviesRepository;

  MovieDetailsPageBloc(this._moviesRepository, this._movieId)
      : assert(_moviesRepository != null),
        assert(_movieId != null);

  @override
  MovieDetailsPageState get initialState => MovieDetailsIsEmpty();

  @override
  Stream<MovieDetailsPageState> mapEventToState(
      MovieDetailsPageState currentState, MovieDetailsPageEvent event) async* {
    if (event is FetchMovieDetails) {
      yield MovieDetailsIsLoading();
      try {
        MovieDetailsWithCreditsResponseRoot details = await _moviesRepository.fetchMovieDetailsWithCredits(_movieId);
        yield MovieDetailsIsLoaded(details);
      } on ApiRequestException catch (e, stacktrace) {
        Log.e(e, stacktrace);
        if (e is LoadingMoviesFailedException) {
          Log.e(e, e.apiResponse);
        }
        yield MovieDetailsError(e.message);
      }
    }
  }
}
