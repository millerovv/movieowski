import 'dart:async';

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
  static const int shimmerOpacityAnimationDurationMills = 3000;

  HomePageBloc _bloc;
  TextEditingController searchController;
  double shimmerOpacity;
  bool showShimmer;

  @override
  void initState() {
    widget.onInit();
    _bloc = BlocProvider.of<HomePageBloc>(context);
    searchController = TextEditingController();
    shimmerOpacity = 1.0;
    showShimmer = true;
    super.initState();
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          new SliverAppBar(
            flexibleSpace: _createSearchBar(),
            pinned: true,
          ),
        ];
      },
      body: BlocBuilder<HomePageEvent, HomePageState>(
        bloc: _bloc,
        builder: (BuildContext context, HomePageState state) {
          if (state is HomePageIsLoaded) {
            if (showShimmer) _closeShimmer();
            shimmerOpacity = 0.0;
          }
          if (state is HomePageLoadingFailed) {
            return Center(
              child: Text('Couldn\'t connect to the server.\nPlease try again later',
                style: Theme.of(context).textTheme.headline,
              ),
            );
          } else {
            return Stack(
              children: <Widget>[
                (state is HomePageIsLoaded) ? _createHomePageContent(context) : SizedBox(),
                showShimmer ? IgnorePointer(
                  child: AnimatedOpacity(
                    opacity: shimmerOpacity,
                    duration: const Duration(milliseconds: shimmerOpacityAnimationDurationMills),
                    child: HomePageShimmer(),
                  ),
                ) : SizedBox(),
              ],
            );
          }
        },
      )
      ),
    );
  }

  Future<void> _closeShimmer() async {
    await Future.delayed(const Duration(milliseconds: shimmerOpacityAnimationDurationMills), () {
      setState(() {
        showShimmer = false;
      });
    });
  }

  Widget _createSearchBar() {
    return Center(
      child: Container(
        height: 24,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(12.0, kStatusBarHeight + 16.0, 12.0, 12.0),
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(
                  Icons.search,
                color: AppColors.hintGrey,
                ),
              ),
              Flexible(
                //https://github.com/flutter/flutter/issues/24705
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 12.0),
                  child: TextField(
                    controller: searchController,
                    style: Theme.of(context).textTheme.body1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hasFloatingPlaceholder: false,
                      hintText: 'Search for any movie or actor',
                    ),
                  ),
                ),
              ),
            ],
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
