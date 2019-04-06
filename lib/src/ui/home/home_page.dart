import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieowski/src/blocs/home_page/actors/popular_actors_section_bloc_export.dart';
import 'package:movieowski/src/blocs/home_page/home_page_bloc_export.dart';
import 'package:movieowski/src/blocs/home_page/movies/movies_section_bloc_export.dart';
import 'package:movieowski/src/blocs/home_page/genres/movie_genres_section_bloc_export.dart';
import 'package:movieowski/src/ui/home/section/categories_section.dart';
import 'package:movieowski/src/ui/home/home_page_shimmer.dart';
import 'package:movieowski/src/ui/home/section/movies_section.dart';
import 'package:movieowski/src/ui/home/section/popular_actors_section.dart';
import 'package:movieowski/src/utils/consts.dart';

class HomePage extends StatefulWidget {
  final void Function() onInit;

  HomePage({Key key, this.onInit}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageBloc _bloc;
  bool _forAndroid;

  @override
  void initState() {
    widget.onInit();
    _bloc = BlocProvider.of<HomePageBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _forAndroid = Theme.of(context).platform == TargetPlatform.android;
    return Scaffold(
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
            return _createHomePageContent(context);
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
    );
  }

  Widget _createSearchBar() {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Container(
          margin: EdgeInsets.fromLTRB(12.0, kStatusBarHeight + 10.0, 12.0, 12.0),
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

  Widget _createHomePageContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          BlocProvider<NowPlayingMoviesSectionBloc>(
            bloc: BlocProvider.of<NowPlayingMoviesSectionBloc>(context),
            child: MoviesSection(MovieSectionType.IN_THEATRES),
          ),
          BlocProvider<TrendingMoviesSectionBloc>(
            bloc: BlocProvider.of<TrendingMoviesSectionBloc>(context),
            child: MoviesSection(MovieSectionType.TRENDING),
          ),
          BlocProvider<PopularActorsSectionBloc>(
            bloc: BlocProvider.of<PopularActorsSectionBloc>(context),
            child: PopularActorsSection(),
          ),
          BlocProvider<UpcomingMoviesSectionBloc>(
            bloc: BlocProvider.of<UpcomingMoviesSectionBloc>(context),
            child: MoviesSection(MovieSectionType.UPCOMING),
          ),
          BlocProvider<MovieGenresSectionBloc>(
            bloc: BlocProvider.of<MovieGenresSectionBloc>(context),
            child: CategoriesSection(),
          )
        ],
      ),
    );
  }
}
