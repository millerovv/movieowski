import 'package:bloc/bloc.dart';
import 'package:movieowski/src/blocs/see_all_page/bloc_movie_list_event.dart';
import 'package:movieowski/src/blocs/see_all_page/bloc_movie_list_state.dart';
import 'package:movieowski/src/model/api/response/base_movies_response.dart';
import 'package:movieowski/src/model/api/response/popular_movies_response.dart';
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
  final List<Movie> preloadedFirstPage;

  /// Max number of movies per fetched page
  final int _moviesPerPage = 12;

  /// List of all the movie pages that have been fetched from Internet.
  /// We use a [Map] to store them, so that we can identify the pageIndex
  /// more easily.
  final _fetchedPages = <int, List<Movie>>{};

  int maxPages;
  int nextPage;

  @override
  MovieListState get initialState => MoviesEmpty();

  @override
  Stream<MovieListState> mapEventToState(MovieListState currentState, MovieListEvent event) async* {
    if (event is FetchMovies) {
      if (event is FetchMoviesWithReset) {
        _fetchedPages.clear();
        nextPage = null;
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
        yield PagesLoaded(_fetchedPages[1], false);
      } else if (!_fetchedPages.containsKey(nextPage) &&
          nextPage <= (maxPages ?? 1)) {
        try {
          nextPage--;
          List<Movie> pages = [];
          while (pages.length < _moviesPerPage) {
            nextPage++;
            final PopularMoviesResponseRoot response =
                await _moviesRepository.fetchPopularMovies(pageIndex: nextPage);
            maxPages = response.totalPages;
            _fetchedPages[nextPage] = response.movies
                .map((movie) => (containsAll(movie.genreIds, filteringGenreIds)) ? movie : null)
                .toList();
            pages.addAll(_fetchedPages[nextPage]..removeWhere((movie) => movie == null));
          }

          List<Movie> movies = <Movie>[];
          _fetchedPages.forEach((key, value) => movies.addAll(value));
          yield PagesLoaded(movies, nextPage == maxPages);
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
