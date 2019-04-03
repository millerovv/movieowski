import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movieowski/src/blocs/home_page/actors/popular_actors_section_bloc_export.dart';
import 'package:movieowski/src/blocs/home_page/bloc_home_page_event.dart';
import 'package:movieowski/src/blocs/home_page/bloc_home_page_state.dart';
import 'package:movieowski/src/blocs/home_page/genres/movie_genres_section_bloc_export.dart';
import 'package:movieowski/src/blocs/home_page/movies/movies_section_bloc_export.dart';

/// This BLOC controls section content loading statuses.
/// Emits [HomePageIsLoaded] state when all sections have been loaded
class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final PopularActorsSectionBloc popularActorsSectionBloc;
  final NowPlayingMoviesSectionBloc nowPlayingMoviesSectionBloc;
  final TrendingMoviesSectionBloc trendingMoviesSectionBloc;
  final UpcomingMoviesSectionBloc upcomingMoviesSectionBloc;
  final MovieGenresSectionBloc movieGenresSectionBloc;

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

  HomePageBloc(
      {@required this.popularActorsSectionBloc,
      @required this.nowPlayingMoviesSectionBloc,
      @required this.trendingMoviesSectionBloc,
      @required this.upcomingMoviesSectionBloc,
      @required this.movieGenresSectionBloc}) {
    _subscribeToSectionBlocs();
  }

  @override
  HomePageState get initialState => HomePageNotLoaded();

  @override
  Stream<HomePageState> mapEventToState(HomePageState currentState, HomePageEvent event) async* {
    if (event is SectionLoadingFailed) {
      yield HomePageLoadingFailed(event.errorMessage);
    } else if (event is StartLoadingHomePage) {
      yield HomePageIsLoading();
    } else {
      if (event is NowPlayingMoviesLoaded) {
        sectionsLoadedStatuses[HomeSection.NOW_PLAYING] = true;
      } else if (event is TrendingMoviesLoaded) {
        sectionsLoadedStatuses[HomeSection.TRENDING] = true;
      } else if (event is PopularActorsLoaded) {
        sectionsLoadedStatuses[HomeSection.ACTORS] = true;
      } else if (event is UpcomingMoviesLoaded) {
        sectionsLoadedStatuses[HomeSection.UPCOMING] = true;
      } else if (event is GenresLoaded) {
        sectionsLoadedStatuses[HomeSection.CATEGORIES] = true;
      }
      if (_allSectionsLoaded()) {
        yield HomePageIsLoaded();
      }
    }
  }

  @override
  void dispose() {
    _unsubscribeFromSectionBlocs();
    super.dispose();
  }
  void _subscribeToSectionBlocs() {
    if (nowPlayingMoviesSectionBloc.state != null) {
      _nowPlayingMoviesSectionSubscription = nowPlayingMoviesSectionBloc.state.listen((MoviesSectionState state) {
        if (state is MoviesIsLoaded) {
          dispatch(NowPlayingMoviesLoaded());
        } else if (state is MoviesError) {
          dispatch(NowPlayingMoviesLoadingFailed(state.errorMessage));
        }
      });
    }
    if (trendingMoviesSectionBloc.state != null) {
      _trendingMoviesSectionSubscription = trendingMoviesSectionBloc.state.listen((MoviesSectionState state) {
        if (state is MoviesIsLoaded) {
          dispatch(TrendingMoviesLoaded());
        } else if (state is MoviesError) {
          dispatch(TrendingMoviesLoadingFailed(state.errorMessage));
        }
      });
    }
    if (upcomingMoviesSectionBloc.state != null) {
      _upcomingMoviesSectionSubscription = upcomingMoviesSectionBloc.state.listen((MoviesSectionState state) {
        if (state is MoviesIsLoaded) {
          dispatch(UpcomingMoviesLoaded());
        } else if (state is MoviesError) {
          dispatch(UpcomingMoviesFailed(state.errorMessage));
        }
      });
    }
    if (popularActorsSectionBloc.state != null) {
      _popularActorsSectionSubscription = popularActorsSectionBloc.state.listen((PopularActorsSectionState state) {
        if (state is PopularActorsIsLoaded) {
          dispatch(PopularActorsLoaded());
        } else if (state is PopularActorsError) {
          dispatch(PopularActorsLoadingFailed(state.errorMessage));
        }
      });
    }
    if (movieGenresSectionBloc.state != null) {
      _movieGenresSectionSubscription = movieGenresSectionBloc.state.listen((MovieGenresSectionState state) {
        if (state is MovieGenresIsLoaded) {
          dispatch(GenresLoaded());
        } else if (state is MovieGenresError) {
          dispatch(GenresLoadingFailed(state.errorMessage));
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
