import 'package:bloc/bloc.dart';
import 'package:movieowski/src/blocs/see_all_page/bloc_movie_list_event.dart';
import 'package:movieowski/src/blocs/see_all_page/bloc_movie_list_state.dart';
import 'package:movieowski/src/model/api/response/base_movies_response.dart';
import 'package:movieowski/src/model/api/response/movie_genres_response.dart';
import 'package:movieowski/src/resources/api/base_api_provider.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';
import 'package:movieowski/src/ui/see_all/see_all_movies_page.dart';
import 'package:movieowski/src/utils/logger.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  MovieListBloc(this._pageType, this._moviesRepository, {this.preloadedFirstPage, this.maxPages})
      : assert(_pageType != null),
        assert(_moviesRepository != null);

  final SeeAllMoviesType _pageType;
  final MoviesRepository _moviesRepository;

  /// Max number of movies per fetched page
  final int _moviesPerPage = 10;

  final int _maxPagesPerRequestSeries = 9;

  /// List of all the movie pages that have been fetched from Internet.
  /// We use a [Map] to store them, so that we can identify the pageIndex
  /// more easily.
  final _fetchedPages = <int, List<Movie>>{};

  List<Movie> preloadedFirstPage;
  List<Genre> movieGenres;
  int maxPages;
  int nextPage;

  @override
  MovieListState get initialState => MoviesEmpty();

  void _fetchGenres() async {
    movieGenres = await _moviesRepository.fetchMovieGenres();
  }

  @override
  Stream<MovieListState> mapEventToState(MovieListState currentState, MovieListEvent event) async* {
    if (event is FetchMovies) {
      if (movieGenres == null) {
        await _fetchGenres();
        movieGenres = movieGenres ?? [];
      }
      if (event is FetchMoviesWithReset) {
        yield MoviesEmpty();
        _fetchedPages.clear();
        preloadedFirstPage = null;
        nextPage = null;
        maxPages = null;
      }
      List<int> filteringGenreIds = event.genres.map((genre) => genre.id).toList();
      nextPage = nextPage ?? 0;
      nextPage++;
      if (nextPage == 1 &&
          !_fetchedPages.containsKey(1) &&
          preloadedFirstPage != null &&
          preloadedFirstPage.isNotEmpty) {
        _fetchedPages[1] = preloadedFirstPage;
        _fetchedPages[1].map((movie) => (containsAll(movie.genreIds, filteringGenreIds)) ? movie : null);
        yield PagesLoaded(_fetchedPages[1], false, movieGenres);
      } else if (!_fetchedPages.containsKey(nextPage) && nextPage <= (maxPages ?? 1)) {
        try {
          nextPage--;
          List<Movie> pages = [];
          int loopCnt = 0;
          while (pages.length < _moviesPerPage && loopCnt < _maxPagesPerRequestSeries) {
            loopCnt++;
            nextPage++;
            BaseMoviesResponse response;
            switch (_pageType) {
              case SeeAllMoviesType.IN_THEATRES:
                response = await _moviesRepository.fetchNowPlayingMovies(pageIndex: nextPage);
                break;
              case SeeAllMoviesType.UPCOMING:
                response = await _moviesRepository.fetchUpcomingMovies(pageIndex: nextPage);
                break;
              case SeeAllMoviesType.POPULAR:
                response = await _moviesRepository.fetchPopularMovies(pageIndex: nextPage);
                break;
              case SeeAllMoviesType.SEARCH_RESULTS:
                break;
            }
            maxPages = response.totalPages;
            _fetchedPages[nextPage] = response.movies
                .map((movie) => (containsAll(movie.genreIds, filteringGenreIds)) ? movie : null)
                .toList();
            pages.addAll(_fetchedPages[nextPage]..removeWhere((movie) => movie == null));
          }
          List<Movie> movies = <Movie>[];
          _fetchedPages.forEach((key, value) => movies.addAll(value));
          yield PagesLoaded(movies, nextPage == maxPages || loopCnt >= _maxPagesPerRequestSeries, movieGenres);
        } on ApiRequestException catch (e, stacktrace) {
          Log.e(e, stacktrace);
          yield MoviesLoadingError(e.message);
        }
      }
    }
  }
}

bool containsAll(List<dynamic> list, List<dynamic> needed) {
  for (dynamic element in needed) {
    if (!list.contains(element)) {
      return false;
    }
  }
  return true;
}
