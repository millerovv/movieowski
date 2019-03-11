import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieowski/src/blocs/home_page/actors/bloc_popular_actors_section.dart';
import 'package:movieowski/src/blocs/home_page/actors/bloc_popular_actors_section_event.dart';
import 'package:movieowski/src/blocs/home_page/genres/bloc_movie_genres_section.dart';
import 'package:movieowski/src/blocs/home_page/genres/bloc_movie_genres_section_event.dart';
import 'package:movieowski/src/blocs/home_page/movies/bloc_movies_section_event.dart';
import 'package:movieowski/src/blocs/home_page/movies/bloc_now_playing_movies_section.dart';
import 'package:movieowski/src/blocs/home_page/movies/bloc_trending_movies_section.dart';
import 'package:movieowski/src/blocs/home_page/movies/bloc_upcoming_movies_section.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';
import 'package:movieowski/src/ui/categories_section.dart';
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
  PopularActorsSectionBloc popularActorsSectionBloc;
  NowPlayingMoviesSectionBloc nowPlayingMoviesSectionBloc;
  TrendingMoviesSectionBloc trendingMoviesSectionBloc;
  UpcomingMoviesSectionBloc upcomingMoviesSectionBloc;
  MovieGenresSectionBloc movieGenresSectionBloc;
  bool _forAndroid;

  @override
  void initState() {
    popularActorsSectionBloc = PopularActorsSectionBloc(widget._moviesRepository);
    nowPlayingMoviesSectionBloc = NowPlayingMoviesSectionBloc(widget._moviesRepository);
    trendingMoviesSectionBloc = TrendingMoviesSectionBloc(widget._moviesRepository);
    upcomingMoviesSectionBloc = UpcomingMoviesSectionBloc(widget._moviesRepository);
    movieGenresSectionBloc = MovieGenresSectionBloc(widget._moviesRepository);
    popularActorsSectionBloc.dispatch(FetchPopularActors());
    nowPlayingMoviesSectionBloc.dispatch(FetchMovies());
    trendingMoviesSectionBloc.dispatch(FetchMovies());
    upcomingMoviesSectionBloc.dispatch(FetchMovies());
    movieGenresSectionBloc.dispatch(FetchGenres());
    super.initState();
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
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                BlocProvider<NowPlayingMoviesSectionBloc>(
                  bloc: nowPlayingMoviesSectionBloc,
                  child: MoviesSection(SectionType.IN_THEATRES),
                ),
                BlocProvider<TrendingMoviesSectionBloc>(
                  bloc: trendingMoviesSectionBloc,
                  child: MoviesSection(SectionType.TRENDING),
                ),
                BlocProvider<PopularActorsSectionBloc>(
                  bloc: popularActorsSectionBloc,
                  child: PopularActorsSection(),
                ),
                BlocProvider<UpcomingMoviesSectionBloc>(
                  bloc: upcomingMoviesSectionBloc,
                  child: MoviesSection(SectionType.UPCOMING),
                ),
                BlocProvider<MovieGenresSectionBloc>(
                  bloc: movieGenresSectionBloc,
                  child: CategoriesSection(),
                )
              ],
            ),
          )),
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
}
