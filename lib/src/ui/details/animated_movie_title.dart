import 'package:flutter/material.dart';
import 'package:movieowski/src/utils/consts.dart';

class AnimatedMovieTitle extends StatefulWidget {
  final String title;
  final String subTitle;

  final AnimationController boardingController;
  final AnimationController transitionController;
  final Animation<double> titleOpacity;
  final Animation<double> titleAlignmentBoardingYOffset;
  final Animation<double> titleAlignmentTransitionYOffset;
  final Animation<double> titleFontSize;
  final Animation<double> subTitleFontSize;
  final Animation<double> titleBottomPadding;

  AnimatedMovieTitle({Key key, this.title, this.subTitle, this.boardingController, this.transitionController})
      : titleOpacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: boardingController,
          curve: Curves.easeIn,
        )),
        titleAlignmentBoardingYOffset = Tween<double>(
          begin: 0.40,
          end: 0.52,
        ).animate(CurvedAnimation(
          parent: boardingController,
          curve: Curves.easeIn,
        )),
        titleAlignmentTransitionYOffset = Tween<double>(
          begin: 0.52,
          end: -0.96,
        ).animate(CurvedAnimation(
          parent: transitionController,
          curve: Interval(0.0, 0.85, curve: Curves.easeIn),
        )),
        titleFontSize = Tween<double>(
          begin: 24.0,
          end: 14.0,
        ).animate(CurvedAnimation(
          parent: transitionController,
          curve: Interval(0.0, 0.85, curve: Curves.easeIn),
        )),
        subTitleFontSize = Tween<double>(
          begin: 14.0,
          end: 10.0,
        ).animate(CurvedAnimation(
          parent: transitionController,
          curve: Interval(0.0, 0.85, curve: Curves.easeIn),
        )),
        titleBottomPadding = Tween<double>(
          begin: 10.0,
          end: 4,
        ).animate(CurvedAnimation(
          parent: transitionController,
          curve: Interval(0.0, 0.85, curve: Curves.easeIn),
        )),
        super(key: key);

  @override
  AnimatedMovieTitleState createState() => AnimatedMovieTitleState();
}

class AnimatedMovieTitleState extends State<AnimatedMovieTitle> {
  AnimationController currentController;
  Animation<double> currentAlignmentAnimation;

  @override
  initState() {
    super.initState();
    currentAlignmentAnimation = widget.titleAlignmentBoardingYOffset;
    currentController = widget.boardingController;
  }

  @override
  void dispose() {
    widget.boardingController?.dispose();
    widget.transitionController?.dispose();
    super.dispose();
  }

  Widget _buildAnimatedAppbarBackground(BuildContext context, Widget child) {
    return Align(
      alignment: Alignment(0.0, currentAlignmentAnimation.value),
      child: Opacity(
        opacity: widget.titleOpacity.value,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline.copyWith(
                    color: AppColors.primaryWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: widget.titleFontSize.value,
                  ),
            ),
            SizedBox(
              height: widget.titleBottomPadding.value,
            ),
            Text(widget.subTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(color: AppColors.primaryWhite, fontSize: widget.subTitleFontSize.value)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: currentController,
      builder: _buildAnimatedAppbarBackground,
    );
  }

  void prepareBoardingAnimation() {
    setState(() {
      currentAlignmentAnimation = widget.titleAlignmentBoardingYOffset;
      currentController = widget.boardingController;
    });
  }

  void prepareTransitionAnimation() {
    setState(() {
      currentAlignmentAnimation = widget.titleAlignmentTransitionYOffset;
      currentController = widget.transitionController;
    });
  }
}
