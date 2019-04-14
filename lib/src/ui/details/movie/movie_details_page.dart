import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieowski/src/blocs/movie_details_page/movie_details_page_bloc_export.dart';
import 'package:movieowski/src/model/api/response/base_movies_response.dart';
import 'package:movieowski/src/model/api/response/movie_details_with_credits_response.dart';
import 'package:movieowski/src/resources/api/tmdp_api_provider.dart';
import 'package:movieowski/src/ui/details/movie/animated_appbar_bg.dart';
import 'package:movieowski/src/ui/details/movie/animated_movie_title.dart';
import 'package:movieowski/src/ui/details/movie/animated_rating.dart';
import 'package:movieowski/src/ui/details/movie/movie_more_details_page.dart';
import 'package:movieowski/src/ui/widget/movie_card.dart';
import 'package:movieowski/src/utils/consts.dart';
import 'package:movieowski/src/utils/ui_utils.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;
  final String posterHeroTag;

  // In the current implementation equals null, when hero animations for rating circle isn't needed
  final String numberRatingHeroTag;

  MovieDetailsPage({Key key, this.movie, this.posterHeroTag, this.numberRatingHeroTag})
      : super(key: key);

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> with TickerProviderStateMixin {
  static const int boardingAnimationDurationMills = 800;
  static const int gradientAppearTimerOffsetMills = 400;
  static const int onShowMoreDetailsAnimationDurationMills = 800;
  static const int ratingAnimationDurationMills = 1400;
  static const int pageSwitchAnimationDurationMills = 1000;

  final GlobalKey<AnimatedMovieTitleState> _animatedTitleKey = new GlobalKey<AnimatedMovieTitleState>();
  final GlobalKey _pageViewKey = new GlobalKey();

  MovieDetailsPageBloc _bloc;
  PageController pageController;

  double gradientHeight;
  double optionButtonsOpacity;
  Timer gradientAppearTimer;

  AnimationController boardingAnimationController;
  AnimationController ratingAnimationController;
  AnimationController onShowMoreDetailsAnimationController;

  Animation<double> backButtonRotateAnimation;

  bool animatedTitlePreparedForTransitionAnim;
  double pageViewHeight;

  void _afterLayout(_) {
    pageViewHeight = _pageViewKey.currentContext.size.height;

    if (pageController.page != pageController.initialPage) {
      setState(() {
        pageController.jumpToPage(pageController.initialPage);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<MovieDetailsPageBloc>(context);
    _bloc.dispatch(FetchMovieDetails());

    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);

    gradientHeight = 0.0;
    optionButtonsOpacity = 0.0;
    animatedTitlePreparedForTransitionAnim = false;

    boardingAnimationController =
        AnimationController(duration: Duration(milliseconds: boardingAnimationDurationMills), vsync: this);
    ratingAnimationController =
        AnimationController(duration: Duration(milliseconds: ratingAnimationDurationMills), vsync: this);
    onShowMoreDetailsAnimationController =
        AnimationController(duration: Duration(milliseconds: onShowMoreDetailsAnimationDurationMills), vsync: this);

    pageController = PageController()
      ..addListener(() {
      if (!animatedTitlePreparedForTransitionAnim) {
        _animatedTitleKey.currentState?.prepareTransitionAnimation();
        animatedTitlePreparedForTransitionAnim = true;
      }
      onShowMoreDetailsAnimationController.value = pageController.offset / pageViewHeight;
    });

    backButtonRotateAnimation = Tween<double>(
      begin: 0.0,
      end: math.pi / 2,
    ).animate(CurvedAnimation(
      parent: onShowMoreDetailsAnimationController,
      curve: Curves.easeInOutCubic,
    ));

    gradientAppearTimer = Timer(const Duration(milliseconds: gradientAppearTimerOffsetMills), () {
      setState(() {
        gradientHeight = 320.0;
        optionButtonsOpacity = 1.0;
      });
    });
  }

  @override
  void dispose() {
    _bloc?.dispose();
    gradientAppearTimer?.cancel();
    pageController?.dispose();
    boardingAnimationController?.dispose();
    ratingAnimationController?.dispose();
    onShowMoreDetailsAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var moviePoster = Hero(
      tag: widget.posterHeroTag,
      transitionOnUserGestures: true,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: Image.network(
          TmdbApiProvider.BASE_IMAGE_URL_W500 + widget.movie.posterPath,
          alignment: Alignment.topCenter,
          fit: BoxFit.cover,
        ),
      ),
    );

    var gradient = AnimatedContainer(
      height: gradientHeight,
      duration: Duration(milliseconds: boardingAnimationDurationMills),
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Colors.transparent,
                AppColors.primaryColorHalfTransparent,
                AppColors.primaryColor,
              ],
            )),
      ),
    );

    var starsRating = AnimatedRating(
      controller: ratingAnimationController.view,
      targetRating: widget.movie.voteAverage,
    );

    var ratingCircle = RatingCircle(
      withHero: widget.numberRatingHeroTag != null,
      heroTag: widget.numberRatingHeroTag,
      rating: widget.movie.voteAverage,
      color: calculateRatingColor(widget.movie.voteAverage),
      diameter: 48.0,
    );

    var optionButtons = AnimatedOpacity(
      opacity: optionButtonsOpacity,
      duration: Duration(milliseconds: boardingAnimationDurationMills),
      child: GestureDetector(
        onTap: _animateToMoreDetailsPage,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'More',
              style: Theme.of(context).textTheme.caption.copyWith(color: AppColors.primaryWhite),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.primaryWhite,
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: <Widget>[
          PageView(
            key: _pageViewKey,
            controller: pageController,
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: moviePoster,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: gradient,
                  ),
                  Align(
                    alignment: Alignment(0.0, 0.59),
                    child: starsRating,
                  ),
                  Align(
                    alignment: Alignment(0.0, 0.82),
                    child: ratingCircle,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: optionButtons,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: kStatusBarHeight),
                child: MovieMoreDetails(),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: AnimatedAppbarBackground(controller: onShowMoreDetailsAnimationController.view),
          ),
          _createAnimatedMovieTitle(),
          AnimatedOpacity(
	          opacity: optionButtonsOpacity,
	          duration: Duration(milliseconds: boardingAnimationDurationMills),
	          child: _createOptionButtons(),
          ),
        ],
      ),
    );
  }

  Widget _createAnimatedMovieTitle() {
    return BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, MovieDetailsPageState state) {
        if (state is MovieDetailsIsLoaded) {
          _animatedTitleKey.currentState?.prepareBoardingAnimation();
          boardingAnimationController.forward();
          ratingAnimationController.forward();
          return AnimatedMovieTitle(
            key: _animatedTitleKey,
            title: widget.movie.title,
            subTitle: '${widget.movie.releaseDate.split('-')[0]} – '
                '${state.details.credits.crew.firstWhere((member) => member.job == 'Director',
                orElse: () => Crew()..name = 'Unknown Director').name}',
            boardingController: boardingAnimationController.view,
            transitionController: onShowMoreDetailsAnimationController.view,
          );
        } else if (state is MovieDetailsIsEmpty || state is MovieDetailsIsLoading) {
          return SizedBox();
        } else {
          return Text(
            'Error occured while trying to get movie info :(',
            style: Theme.of(context).textTheme.headline.copyWith(color: AppColors.primaryWhite),
          );
        }
      },
    );
  }

  Widget _createOptionButtons() {
    Widget buildAnimatedBackIcon(BuildContext context, Widget child) {
      return Transform.rotate(
        angle: backButtonRotateAnimation.value,
        child: Icon(
          Icons.keyboard_arrow_left,
          size: 36.0,
          color: AppColors.primaryWhite,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: kStatusBarHeight),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: _backButtonPressed,
            child: Padding(
              padding: const EdgeInsets.only(left: 6.0, top: 10.0),
              child: AnimatedBuilder(animation: onShowMoreDetailsAnimationController, builder: buildAnimatedBackIcon),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 10.0),
            child: Icon(
              Icons.favorite_border,
              size: 28.0,
              color: AppColors.primaryWhite,
            ),
          ),
        ],
      ),
    );
  }

  void _animateToMoreDetailsPage() {
    pageController.nextPage(
      duration: Duration(milliseconds: pageSwitchAnimationDurationMills),
      curve: Curves.easeInOut,
    );
    _animatedTitleKey.currentState.prepareTransitionAnimation();
    animatedTitlePreparedForTransitionAnim = true;
  }

  void _backButtonPressed() {
    if (pageController.page == 0) {
      Navigator.pop(context);
    } else if (pageController.page == 1) {
      pageController.animateTo(0,
          duration: Duration(milliseconds: pageSwitchAnimationDurationMills), curve: Curves.easeInOut);
    }
  }
}
