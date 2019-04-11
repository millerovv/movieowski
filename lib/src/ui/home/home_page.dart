import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieowski/src/blocs/home_page/actors/popular_actors_section_bloc_export.dart';
import 'package:movieowski/src/blocs/home_page/home_page_bloc_export.dart';
import 'package:movieowski/src/blocs/home_page/movies/movies_section_bloc_export.dart';
import 'package:movieowski/src/blocs/home_page/genres/movie_genres_section_bloc_export.dart';
import 'package:movieowski/src/ui/home/query_search_results.dart';
import 'package:movieowski/src/ui/home/section/categories_section.dart';
import 'package:movieowski/src/ui/home/home_page_shimmer.dart';
import 'package:movieowski/src/ui/home/section/movies_section.dart';
import 'package:movieowski/src/ui/home/section/popular_actors_section.dart';
import 'package:movieowski/src/ui/widget/search_bar.dart';
import 'package:movieowski/src/utils/consts.dart';

class HomePage extends StatefulWidget {
  final void Function() onInit;

  HomePage({Key key, this.onInit}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  static const int shimmerOpacityAnimationDurationMills = 3000;
  static const int searchFocusAnimationDurationMills = 500;

  HomePageBloc _bloc;
  TextEditingController searchController;
  FocusNode searchFocusNode;
  double shimmerOpacity;
  bool showShimmer;

  bool showClearSearchButton;
  bool searchIsFocused;

  Animation<Color> backgroundColor;
  AnimationController searchFocusAnimationController;

  @override
  void initState() {
    widget.onInit();
    _bloc = BlocProvider.of<HomePageBloc>(context);

    searchFocusAnimationController =
        AnimationController(duration: Duration(milliseconds: searchFocusAnimationDurationMills), vsync: this)
          ..addListener(() {
            setState(() {});
          });
    backgroundColor =
        ColorTween(begin: AppColors.primaryColor, end: AppColors.darkerPrimary).animate(searchFocusAnimationController);

    showClearSearchButton = false;
    searchIsFocused = false;
    searchController = TextEditingController();
    searchFocusNode = FocusNode()
      ..addListener(() {
        setState(() {
          if (searchFocusNode.hasFocus) {
            searchFocusAnimationController.forward();
            showClearSearchButton = true;
            searchIsFocused = true;
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

  void _onSearchBarValueChangeCallback(String value) {
    if (value.isNotEmpty) {
      _bloc.dispatchSearchQuery(value);
    } else {
      _bloc.dispatch(CancelSearch());
    }
  }

  void _onCancelSearchBarButtonClickCallback() {
    _bloc.dispatch(CancelSearch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor.value,
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                backgroundColor: backgroundColor.value,
                pinned: true,
                flexibleSpace: SearchBar(
                  textFieldController: searchController,
                  focusNode: searchFocusNode,
                  showClearSearchButton: showClearSearchButton,
                  onChanged: _onSearchBarValueChangeCallback,
                  onCancelButtonClick: _onCancelSearchBarButtonClickCallback,
                ),
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
                    (state is SearchByQueryIsLoading || state is SearchByQueryIsLoaded)
                        ? QuerySearchResults(
                            loaded: state is SearchByQueryIsLoaded,
                            moviesRoot: (state is SearchByQueryIsLoaded) ? state.movies : null,
                            peopleRoot: (state is SearchByQueryIsLoaded) ? state.people : null,
                            moviesRepository: _bloc.moviesRepository,
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
