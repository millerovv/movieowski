import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieowski/src/blocs/movie_details_page/movie_details_page_bloc_export.dart';
import 'package:movieowski/src/model/api/response/base_movies_response.dart';
import 'package:movieowski/src/resources/api/tmdp_api_provider.dart';
import 'package:movieowski/src/ui/details/animated_appbar_bg.dart';
import 'package:movieowski/src/ui/details/animated_movie_title.dart';
import 'package:movieowski/src/ui/details/animated_rating.dart';
import 'package:movieowski/src/ui/details/movie_more_details_page.dart';
import 'package:movieowski/src/utils/consts.dart';
import 'package:movieowski/src/utils/ui_utils.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;
  final String posterHeroTag;

  // In the current implementation equals null, when hero animations for rating circle isn't needed
  final String numberRatingHeroTag;

  MovieDetailsPage({Key key, this.movie, this.posterHeroTag, this.numberRatingHeroTag}) : super(key: key);

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> with TickerProviderStateMixin {
  static const int boardingAnimationDurationMills = 800;
  static const int onShowMoreDetailsAnimationDurationMills = 800;
  static const int ratingAnimationDurationMills = 1400;
  static const int pageSwitchAnimationDurationMills = 1400;

  static final GlobalKey<AnimatedMovieTitleState> animatedTitleKey = new GlobalKey<AnimatedMovieTitleState>();

  MovieDetailsPageBloc _bloc;
  PageController pageController;

  double gradientHeight = 0;
  Timer boardingAnimationTimer;

  AnimationController boardingAnimationController;
  AnimationController ratingAnimationController;
  AnimationController onShowMoreDetailsAnimationController;

  Animation<double> backButtonRotateAnimation;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<MovieDetailsPageBloc>(context);
    _bloc.dispatch(FetchMovieDetails());
    pageController = PageController();
    boardingAnimationController =
        AnimationController(duration: Duration(milliseconds: boardingAnimationDurationMills), vsync: this);
    ratingAnimationController =
        AnimationController(duration: Duration(milliseconds: ratingAnimationDurationMills), vsync: this);
    onShowMoreDetailsAnimationController =
        AnimationController(duration: Duration(milliseconds: onShowMoreDetailsAnimationDurationMills), vsync: this);

    backButtonRotateAnimation = Tween<double>(
      begin: 0.0,
      end: math.pi / 2,
    ).animate(CurvedAnimation(
      parent: onShowMoreDetailsAnimationController,
      curve: Curves.easeInOutCubic,
    ));

    boardingAnimationTimer = Timer(const Duration(milliseconds: 100), () {
      setState(() {
        gradientHeight = 320.0;
        animatedTitleKey.currentState.prepareBoardingAnimation();
        boardingAnimationController.forward();
        ratingAnimationController.forward();
      });
    });
  }

  @override
  void dispose() {
    _bloc?.dispose();
    boardingAnimationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Stack(
          children: <Widget>[
            PageView(
              controller: pageController,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                Stack(
                  fit: StackFit.expand,
                  children: <Widget>[

                    // Poster
                    Align(
                      alignment: Alignment.topCenter,
                      child: Hero(
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
                      ),
                    ),

                    // Gradient
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: AnimatedContainer(
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
                      ),
                    ),

                    // Stars rating
                    Align(
                      alignment: Alignment(0.0, 0.59),
                      child: AnimatedRating(
                        controller: ratingAnimationController,
                        targetRating: widget.movie.voteAverage,
                      ),
                    ),

                    // Rating Circle
                    Align(
                      alignment: Alignment(0.0, 0.82),
                      child: _createRatingCircle(widget.numberRatingHeroTag != null, widget.numberRatingHeroTag),
                    ),

                    // More details button
                    Align(
                      alignment: Alignment.bottomCenter,
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
                    ),
                  ],
                ),
                MovieMoreDetails(),
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: AnimatedAppbarBackground(controller: onShowMoreDetailsAnimationController.view),
            ),
            AnimatedMovieTitle(
              key: animatedTitleKey,
              title: widget.movie.title,
              subTitle: '${widget.movie.releaseDate.split('-')[0].toString()} – Quentin Tarantino',
              boardingController: boardingAnimationController.view,
              transitionController: onShowMoreDetailsAnimationController.view,
            ),
            _createOptionButtons(),
          ],
        ),
      ),
    );
  }

  // Возможно стоит вынести кнопку назад в отедльный виджет
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 6.0, top: 10.0),
          child: AnimatedBuilder(animation: onShowMoreDetailsAnimationController, builder: buildAnimatedBackIcon),
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
    );
  }

  Widget _createRatingCircle(bool withHeroTransition, String heroTag) {
    return (withHeroTransition)
        ? Hero(
            tag: heroTag,
            transitionOnUserGestures: true,
            child: Container(
              width: 48.0,
              height: 48.0,
              decoration: BoxDecoration(
                  color: calculateRatingColor(widget.movie.voteAverage),
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black87,
                      offset: Offset(1.0, 1.0),
                      blurRadius: 4.0,
                    ),
                  ]),
              child: Center(
                child: Text(
                  widget.movie.voteAverage.toString(),
                  style: Theme.of(context).textTheme.body1.copyWith(
                        color: AppColors.primaryWhite,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          )
        : Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
                color: calculateRatingColor(widget.movie.voteAverage),
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black87,
                    offset: Offset(1.0, 1.0),
                    blurRadius: 4.0,
                  ),
                ]),
            child: Center(
              child: Text(
                widget.movie.voteAverage.toString(),
                style: Theme.of(context).textTheme.body1.copyWith(
                      color: AppColors.primaryWhite,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          );
  }

  void _animateToMoreDetailsPage() {
    pageController.animateToPage(
      1,
      duration: Duration(milliseconds: pageSwitchAnimationDurationMills),
      curve: Curves.easeInOut,
    );
    animatedTitleKey.currentState.prepareTransitionAnimation();
    onShowMoreDetailsAnimationController.forward();
  }
}