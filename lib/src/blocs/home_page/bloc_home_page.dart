import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movieowski/src/blocs/home_page/actors/popular_actors_section_bloc_export.dart';
import 'package:movieowski/src/blocs/home_page/bloc_home_page_event.dart';
import 'package:movieowski/src/blocs/home_page/bloc_home_page_state.dart';
import 'package:movieowski/src/blocs/home_page/genres/movie_genres_section_bloc_export.dart';
import 'package:movieowski/src/blocs/home_page/movies/movies_section_bloc_export.dart';
import 'package:movieowski/src/model/api/response/search_movies_response.dart';
import 'package:movieowski/src/model/api/response/search_people_response.dart';
import 'package:movieowski/src/resources/api/base_api_provider.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';
import 'package:movieowski/src/utils/logger.dart';
import 'package:rxdart/rxdart.dart';

/// This BLOC controls section content loading statuses.
/// Emits [HomePageIsLoaded] state when all sections have been loaded
class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final PopularActorsSectionBloc popularActorsSectionBloc;
  final NowPlayingMoviesSectionBloc nowPlayingMoviesSectionBloc;
  final TrendingMoviesSectionBloc trendingMoviesSectionBloc;
  final UpcomingMoviesSectionBloc upcomingMoviesSectionBloc;
  final MovieGenresSectionBloc movieGenresSectionBloc;
  final MoviesRepository moviesRepository;

  final Map<HomeSection, bool> sectionsLoadedStatuses = {
    HomeSection.NOW_PLAYING: false,
    HomeSection.TRENDING: false,
    HomeSection.ACTORS: false,
    HomeSection.UPCOMING: false,
    HomeSection.CATEGORIES: false
  };

  StreamSubscription<MoviesSectionState> _nowPlayingMoviesSectionSubscription;
  StreamSubscription<MoviesSectionState> _trendingMoviesSectionSubscription;
  StreamSubscription<MoviesSectionState> _upcomingMoviesSectionSubscription;
  StreamSubscription<PopularActorsSectionState> _popularActorsSectionSubscription;
  StreamSubscription<MovieGenresSectionState> _movieGenresSectionSubscription;
  BehaviorSubject<String> _searchQueriesSubject;

  bool homePageLoadingFailed;
  String errorMessage;
  bool searchIsAllowed;

  HomePageBloc({
    @required this.popularActorsSectionBloc,
    @required this.nowPlayingMoviesSectionBloc,
    @required this.trendingMoviesSectionBloc,
    @required this.upcomingMoviesSectionBloc,
    @required this.movieGenresSectionBloc,
    @required this.moviesRepository,
  }) {
    assert(popularActorsSectionBloc != null);
    assert(nowPlayingMoviesSectionBloc != null);
    assert(trendingMoviesSectionBloc != null);
    assert(upcomingMoviesSectionBloc != null);
    assert(movieGenresSectionBloc != null);
    assert(moviesRepository != null);
    homePageLoadingFailed = false;
    searchIsAllowed = false;
    _subscribeToSectionBlocs();
    _initSearchQueriesSubject();
  }
  
  void _initSearchQueriesSubject() {
    _searchQueriesSubject = BehaviorSubject<String>();
    _searchQueriesSubject.debounce(Duration(milliseconds: 300))
        .where((query) => query.isNotEmpty)
        .listen((query) => searchIsAllowed ? dispatch(FetchSearchByQuery(query)) : null);
  }

  void dispatchSearchQuery(String query) {
    searchIsAllowed = true;
    _searchQueriesSubject.add(query);
  }

  void cancelSearch() {
    searchIsAllowed = false;
    dispatch(CancelSearch());
  }

  @override
  HomePageState get initialState => HomePageNotLoaded();

  @override
  Stream<HomePageState> mapEventToState(HomePageState currentState, HomePageEvent event) async* {
    if (event is NotifySectionLoadingFailed) {
      homePageLoadingFailed = true;
      errorMessage = event.errorMessage;
      yield HomePageLoadingFailed(event.errorMessage);
    } else if (event is StartLoadingHomePage) {
      yield HomePageIsLoading();
    } else if (event is FetchSearchByQuery) {
      yield SearchByQueryIsLoading();
      try {
        final SearchMoviesResponseRoot moviesRoot = await moviesRepository.fetchMoviesByQuery(event.query);
        final SearchPeopleResponseRoot peopleRoot = await moviesRepository.fetchPeopleByQuery(event.query);
        yield SearchByQueryIsLoaded(moviesRoot, peopleRoot);
      } on ApiRequestException catch (e, stacktrace) {
        Log.e(e, stacktrace);
        yield SearchByQueryLoadingFailed(e.message);
      }
    } else if (event is CancelSearch) {
      if (homePageLoadingFailed) {
        yield HomePageLoadingFailed(errorMessage);
      } else {
        yield (_allSectionsLoaded()) ? HomePageIsLoaded() : HomePageIsLoading();
      }
    } else {
      if (event is NotifyNowPlayingMoviesLoaded) {
        sectionsLoadedStatuses[HomeSection.NOW_PLAYING] = true;
      } else if (event is NotifyTrendingMoviesLoaded) {
        sectionsLoadedStatuses[HomeSection.TRENDING] = true;
      } else if (event is NotifyPopularActorsLoaded) {
        sectionsLoadedStatuses[HomeSection.ACTORS] = true;
      } else if (event is NotifyUpcomingMoviesLoaded) {
        sectionsLoadedStatuses[HomeSection.UPCOMING] = true;
      } else if (event is NotifyGenresLoaded) {
        sectionsLoadedStatuses[HomeSection.CATEGORIES] = true;
      }
      if (_allSectionsLoaded()) {
        homePageLoadingFailed = false;
        yield HomePageIsLoaded();
      }
    }
  }

  @override
  void dispose() {
    _unsubscribeFromSectionBlocs();
    _searchQueriesSubject.close();
    super.dispose();
  }

  void _subscribeToSectionBlocs() {
    if (nowPlayingMoviesSectionBloc.state != null) {
      _nowPlayingMoviesSectionSubscription = nowPlayingMoviesSectionBloc.state.listen((MoviesSectionState state) {
        if (state is MoviesIsLoaded) {
          dispatch(NotifyNowPlayingMoviesLoaded());
        } else if (state is MoviesError) {
          dispatch(NotifyNowPlayingMoviesLoadingFailed(state.errorMessage));
        }
      });
    }
    if (trendingMoviesSectionBloc.state != null) {
      _trendingMoviesSectionSubscription = trendingMoviesSectionBloc.state.listen((MoviesSectionState state) {
        if (state is MoviesIsLoaded) {
          dispatch(NotifyTrendingMoviesLoaded());
        } else if (state is MoviesError) {
          dispatch(NotifyTrendingMoviesLoadingFailed(state.errorMessage));
        }
      });
    }
    if (upcomingMoviesSectionBloc.state != null) {
      _upcomingMoviesSectionSubscription = upcomingMoviesSectionBloc.state.listen((MoviesSectionState state) {
        if (state is MoviesIsLoaded) {
          dispatch(NotifyUpcomingMoviesLoaded());
        } else if (state is MoviesError) {
          dispatch(NotifyUpcomingMoviesFailed(state.errorMessage));
        }
      });
    }
    if (popularActorsSectionBloc.state != null) {
      _popularActorsSectionSubscription = popularActorsSectionBloc.state.listen((PopularActorsSectionState state) {
        if (state is PopularActorsIsLoaded) {
          dispatch(NotifyPopularActorsLoaded());
        } else if (state is PopularActorsError) {
          dispatch(NotifyPopularActorsLoadingFailed(state.errorMessage));
        }
      });
    }
    if (movieGenresSectionBloc.state != null) {
      _movieGenresSectionSubscription = movieGenresSectionBloc.state.listen((MovieGenresSectionState state) {
        if (state is MovieGenresIsLoaded) {
          dispatch(NotifyGenresLoaded());
        } else if (state is MovieGenresError) {
          dispatch(NotifyGenresLoadingFailed(state.errorMessage));
        }
      });
    }
  }

  void _unsubscribeFromSectionBlocs() {
    if (_nowPlayingMoviesSectionSubscription != null) {
      _nowPlayingMoviesSectionSubscription.cancel();
      _nowPlayingMoviesSectionSubscription = null;
    }
    if (_trendingMoviesSectionSubscription != null) {
      _trendingMoviesSectionSubscription.cancel();
      _trendingMoviesSectionSubscription = null;
    }
    if (_upcomingMoviesSectionSubscription != null) {
      _upcomingMoviesSectionSubscription.cancel();
      _upcomingMoviesSectionSubscription = null;
    }
    if (_popularActorsSectionSubscription != null) {
      _popularActorsSectionSubscription.cancel();
      _popularActorsSectionSubscription = null;
    }
    if (_movieGenresSectionSubscription != null) {
      _movieGenresSectionSubscription.cancel();
      _movieGenresSectionSubscription = null;
    }
  }

  bool _allSectionsLoaded() {
    int loadedCnt = 0;
    sectionsLoadedStatuses.values.forEach((status) => status ? loadedCnt++ : null);
    return loadedCnt == HomeSection.values.length;
  }
}

enum HomeSection { NOW_PLAYING, TRENDING, ACTORS, UPCOMING, CATEGORIES }
