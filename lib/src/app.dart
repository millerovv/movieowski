import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieowski/src/blocs/home_page/actors/popular_actors_section_bloc_export.dart';
import 'package:movieowski/src/blocs/home_page/bloc_home_page.dart';
import 'package:movieowski/src/blocs/home_page/bloc_home_page_event.dart';
import 'package:movieowski/src/blocs/home_page/genres/movie_genres_section_bloc_export.dart';
import 'package:movieowski/src/blocs/home_page/movies/movies_section_bloc_export.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';
import 'package:movieowski/src/ui/home/home_page.dart';
import 'package:movieowski/src/utils/consts.dart';

/// Base application class
class MovieowskiApp extends StatefulWidget {
  final MoviesRepository moviesRepository;

  final PopularActorsSectionBloc popularActorsSectionBloc;
  final NowPlayingMoviesSectionBloc nowPlayingMoviesSectionBloc;
  final TrendingMoviesSectionBloc trendingMoviesSectionBloc;
  final UpcomingMoviesSectionBloc upcomingMoviesSectionBloc;
  final MovieGenresSectionBloc movieGenresSectionBloc;

  MovieowskiApp(this.moviesRepository)
      : popularActorsSectionBloc = PopularActorsSectionBloc(moviesRepository),
        nowPlayingMoviesSectionBloc = NowPlayingMoviesSectionBloc(moviesRepository),
        trendingMoviesSectionBloc = TrendingMoviesSectionBloc(moviesRepository),
        upcomingMoviesSectionBloc = UpcomingMoviesSectionBloc(moviesRepository),
        movieGenresSectionBloc = MovieGenresSectionBloc(moviesRepository);

  @override
  _MovieowskiAppState createState() => _MovieowskiAppState();
}

class _MovieowskiAppState extends State<MovieowskiApp> {
  HomePageBloc _homePageBloc;

  @override
  void initState() {
    _homePageBloc = HomePageBloc(
        popularActorsSectionBloc: widget.popularActorsSectionBloc,
        nowPlayingMoviesSectionBloc: widget.nowPlayingMoviesSectionBloc,
        trendingMoviesSectionBloc: widget.trendingMoviesSectionBloc,
        upcomingMoviesSectionBloc: widget.upcomingMoviesSectionBloc,
        movieGenresSectionBloc: widget.movieGenresSectionBloc,
        moviesRepository: widget.moviesRepository);
    _homePageBloc.dispatch(StartLoadingHomePage());
    super.initState();
  }

  @override
  void dispose() {
//    widget.popularActorsSectionBloc?.dispose();
//    widget.nowPlayingMoviesSectionBloc?.dispose();
//    widget.trendingMoviesSectionBloc?.dispose();
//    widget.upcomingMoviesSectionBloc?.dispose();
//    widget.movieGenresSectionBloc?.dispose();
//    _homePageBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Movieowski',
        theme: ThemeData(
            primaryColor: AppColors.primaryColor,
            primaryColorDark: AppColors.primaryColor,
            accentColor: AppColors.accentColor,
            textTheme: TextTheme(
              headline: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryWhite),
            )),
        home: BlocProviderTree(
          blocProviders: [
            BlocProvider<HomePageBloc>(bloc: _homePageBloc),
            BlocProvider<PopularActorsSectionBloc>(bloc: widget.popularActorsSectionBloc),
            BlocProvider<NowPlayingMoviesSectionBloc>(bloc: widget.nowPlayingMoviesSectionBloc),
            BlocProvider<TrendingMoviesSectionBloc>(bloc: widget.trendingMoviesSectionBloc),
            BlocProvider<UpcomingMoviesSectionBloc>(bloc: widget.upcomingMoviesSectionBloc),
            BlocProvider<MovieGenresSectionBloc>(bloc: widget.movieGenresSectionBloc),
          ],
          child: HomePage(onInit: () {
            widget.popularActorsSectionBloc.dispatch(FetchPopularActors());
            widget.nowPlayingMoviesSectionBloc.dispatch(FetchMovies());
            widget.trendingMoviesSectionBloc.dispatch(FetchMovies());
            widget.upcomingMoviesSectionBloc.dispatch(FetchMovies());
            widget.movieGenresSectionBloc.dispatch(FetchGenres());
          },),
        ));
  }
}
