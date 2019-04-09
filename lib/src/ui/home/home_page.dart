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
  FocusNode searchFocusNode;
  double shimmerOpacity;
  bool showShimmer;
  
  bool showClearSearchButton;
  bool searchIsFocused;

  @override
  void initState() {
    widget.onInit();
    _bloc = BlocProvider.of<HomePageBloc>(context);

    showClearSearchButton = false;
    searchIsFocused = false;
    searchController = TextEditingController();
    searchFocusNode = FocusNode()
    ..addListener(() {
      setState(() {
        if (searchFocusNode.hasFocus) {
          showClearSearchButton = true;
          searchIsFocused = true;
        } else {
          showClearSearchButton = false;
          searchIsFocused = false;
        }
      });
    });

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
      backgroundColor: searchIsFocused ? AppColors.darkerPrimary : Theme.of(context).primaryColor,
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
                  child: Text(
                    'Couldn\'t connect to the server.\nPlease try again later',
                    style: Theme.of(context).textTheme.headline,
                  ),
                );
              } else {
                return Stack(
                  children: <Widget>[
                    (state is HomePageIsLoaded) ? _createHomePageContent(context) : SizedBox(),
                    showShimmer
                        ? IgnorePointer(
                            child: AnimatedOpacity(
                              opacity: shimmerOpacity,
                              duration: const Duration(milliseconds: shimmerOpacityAnimationDurationMills),
                              child: HomePageShimmer(),
                            ),
                          )
                        : SizedBox(),
                  ],
                );
              }
            },
          )),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
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
                      size: 22.0,
                      color: AppColors.hintGrey,
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: searchController,
                        focusNode: searchFocusNode,
                        style: Theme.of(context).textTheme.subhead,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        textCapitalization: TextCapitalization.sentences,
                        cursorColor: Colors.black87,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            // Set contentPadding to prevent incorrect layout of this TextField (bug?)
                            contentPadding: EdgeInsets.all(0.0),
                            hintText: 'Search for any movie or actor',
                            hintStyle: Theme.of(context).textTheme.body1.copyWith(color: AppColors.hintGrey)),
                      ),
                    ),
                  ),
                  showClearSearchButton ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.clear,
                      size: 22.0,
                      color: AppColors.hintGrey,
                    ),
                  ) : SizedBox(),
                ],
              ),
            ),
          ),
        ),
        searchIsFocused ? Padding(
          padding: const EdgeInsets.only(top: 22.0, right: 12.0),
          child: Text(
            'Cancel',
            style: Theme.of(context).textTheme.body1.copyWith(color: AppColors.primaryWhite),
          ),
        ) : SizedBox(),
      ],
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
