import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieowski/src/blocs/home_page/actors/popular_actors_section_bloc_export.dart';
import 'package:movieowski/src/blocs/home_page/home_page_bloc_export.dart';
import 'package:movieowski/src/blocs/home_page/movies/movies_section_bloc_export.dart';
import 'package:movieowski/src/blocs/home_page/genres/movie_genres_section_bloc_export.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';
import 'package:movieowski/src/ui/categories_section.dart';
import 'package:movieowski/src/ui/home_page_shimmer.dart';
import 'package:movieowski/src/ui/movies_section.dart';
import 'package:movieowski/src/ui/popular_actors_section.dart';
import 'package:movieowski/src/utils/consts.dart';

class HomePage extends StatefulWidget {
  final MoviesRepository _moviesRepository;

  HomePage(this._moviesRepository) : assert(_moviesRepository != null);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageBloc _bloc;
  PopularActorsSectionBloc popularActorsSectionBloc;
  NowPlayingMoviesSectionBloc nowPlayingMoviesSectionBloc;
  TrendingMoviesSectionBloc trendingMoviesSectionBloc;
  UpcomingMoviesSectionBloc upcomingMoviesSectionBloc;
  MovieGenresSectionBloc movieGenresSectionBloc;
  bool _forAndroid;

  StreamSubscription<MoviesSectionState> _nowPlayingMoviesSectionSubscription;
  StreamSubscription<MoviesSectionState> _trendingMoviesSectionSubscription;
  StreamSubscription<MoviesSectionState> _upcomingMoviesSectionSubscription;
  StreamSubscription<PopularActorsSectionState> _popularActorsSectionSubscription;
  StreamSubscription<MovieGenresSectionState> _movieGenresSectionSubscription;

  @override
  void initState() {
    _bloc = BlocProvider.of<HomePageBloc>(context);
    popularActorsSectionBloc = PopularActorsSectionBloc(widget._moviesRepository);
    nowPlayingMoviesSectionBloc = NowPlayingMoviesSectionBloc(widget._moviesRepository);
    trendingMoviesSectionBloc = TrendingMoviesSectionBloc(widget._moviesRepository);
    upcomingMoviesSectionBloc = UpcomingMoviesSectionBloc(widget._moviesRepository);
    movieGenresSectionBloc = MovieGenresSectionBloc(widget._moviesRepository);
    _subscribeToSectionBlocs();
    popularActorsSectionBloc.dispatch(FetchPopularActors());
    nowPlayingMoviesSectionBloc.dispatch(FetchMovies());
    trendingMoviesSectionBloc.dispatch(FetchMovies());
    upcomingMoviesSectionBloc.dispatch(FetchMovies());
    movieGenresSectionBloc.dispatch(FetchGenres());
    super.initState();
  }

  @override
  void dispose() {
    _unsubscribeFromSectionBlocs();
    _bloc?.dispose();
    popularActorsSectionBloc?.dispose();
    nowPlayingMoviesSectionBloc?.dispose();
    trendingMoviesSectionBloc?.dispose();
    upcomingMoviesSectionBloc?.dispose();
    movieGenresSectionBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _forAndroid = Theme.of(context).platform == TargetPlatform.android;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                flexibleSpace: _createSearchBar(),
                floating: _forAndroid,
                snap: _forAndroid,
                pinned: !_forAndroid,
              ),
            ];
          },
          body: BlocBuilder<HomePageEvent, HomePageState>(
            bloc: _bloc,
            builder: (BuildContext context, HomePageState state) {
              if (state is HomePageNotLoaded || state is HomePageIsLoading) {
                return HomePageShimmer();
              } else if (state is HomePageIsLoaded) {
                return _createHomePageContent();
              } else {
                return Center(
                  child: Text('Couldn\'t connect to the server.\nPlease try again later',
                    style: Theme.of(context).textTheme.headline,
                  ),
                );
              }
            },
          )
      ),
    ));
  }

  Widget _createSearchBar() {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Container(
          margin: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: _forAndroid ? AppColors.primaryWhite : AppColors.lighterPrimary,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            boxShadow: _forAndroid
                ? <BoxShadow>[
                    BoxShadow(
                      color: Colors.black87,
                      offset: Offset(1.0, 1.0),
                      blurRadius: 4.0,
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Icon(
                    Icons.search,
                    color: _forAndroid ? AppColors.hintGrey : AppColors.hintWhite,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Search for any movie or actor',
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(color: _forAndroid ? AppColors.hintGrey : AppColors.hintWhite),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createHomePageContent() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          BlocProvider<NowPlayingMoviesSectionBloc>(
            bloc: nowPlayingMoviesSectionBloc,
            child: MoviesSection(MovieSectionType.IN_THEATRES),
          ),
          BlocProvider<TrendingMoviesSectionBloc>(
            bloc: trendingMoviesSectionBloc,
            child: MoviesSection(MovieSectionType.TRENDING),
          ),
          BlocProvider<PopularActorsSectionBloc>(
            bloc: popularActorsSectionBloc,
            child: PopularActorsSection(),
          ),
          BlocProvider<UpcomingMoviesSectionBloc>(
            bloc: upcomingMoviesSectionBloc,
            child: MoviesSection(MovieSectionType.UPCOMING),
          ),
          BlocProvider<MovieGenresSectionBloc>(
            bloc: movieGenresSectionBloc,
            child: CategoriesSection(),
          )
        ],
      ),
    );
  }

  void _subscribeToSectionBlocs() {
    if (nowPlayingMoviesSectionBloc.state != null) {
      _nowPlayingMoviesSectionSubscription = nowPlayingMoviesSectionBloc.state.skip(1).listen((MoviesSectionState state) {
        if (state is MoviesIsLoaded) {
          _bloc.dispatch(NowPlayingMoviesLoaded());
        } else if (state is MoviesError) {
          _bloc.dispatch(NowPlayingMoviesLoadingFailed(state.errorMessage));
        }
      });
    }
    if (trendingMoviesSectionBloc.state != null) {
      _trendingMoviesSectionSubscription = trendingMoviesSectionBloc.state.skip(1).listen((MoviesSectionState state) {
        if (state is MoviesIsLoaded) {
          _bloc.dispatch(TrendingMoviesLoaded());
        } else if (state is MoviesError) {
          _bloc.dispatch(TrendingMoviesLoadingFailed(state.errorMessage));
        }
      });
    }
    if (upcomingMoviesSectionBloc.state != null) {
      _upcomingMoviesSectionSubscription = upcomingMoviesSectionBloc.state.skip(1).listen((MoviesSectionState state) {
        if (state is MoviesIsLoaded) {
          _bloc.dispatch(UpcomingMoviesLoaded());
        } else if (state is MoviesError) {
          _bloc.dispatch(UpcomingMoviesFailed(state.errorMessage));
        }
      });
    }
    if (popularActorsSectionBloc.state != null) {
      _popularActorsSectionSubscription = popularActorsSectionBloc.state.skip(1).listen((PopularActorsSectionState state) {
        if (state is PopularActorsIsLoaded) {
          _bloc.dispatch(PopularActorsLoaded());
        } else if (state is PopularActorsError) {
          _bloc.dispatch(PopularActorsLoadingFailed(state.errorMessage));
        }
      });
    }
    if (movieGenresSectionBloc.state != null) {
      _movieGenresSectionSubscription = movieGenresSectionBloc.state.skip(1).listen((MovieGenresSectionState state) {
        if (state is MovieGenresIsLoaded) {
          _bloc.dispatch(GenresLoaded());
        } else if (state is MovieGenresError) {
          _bloc.dispatch(GenresLoadingFailed(state.errorMessage));
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
}
