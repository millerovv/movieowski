import 'package:flutter/material.dart';
import 'package:movieowski/src/ui/details/movie/stars.dart';
import 'package:movieowski/src/utils/consts.dart';

class AnimatedRating extends StatefulWidget {
  final AnimationController controller;
  final double targetRating;

  AnimatedRating({Key key, this.controller, this.targetRating}) : super(key: key);

  @override
  _AnimatedRatingState createState() => _AnimatedRatingState();
}

class _AnimatedRatingState extends State<AnimatedRating> {
  static const double starsWidth = 92.0;
  int _numberOfColorStages;
  int _currentColorStage;
  double singleColorStageControllerValueInterval;
  Animation<double> starsPercent;
  Animation<double> starsOpacity;
  Animation colorRed;
  Animation<Color> colorRedToOrange;
  Animation<Color> colorOrangeToYellow;
  Animation<Color> colorYellowToLightGreen;
  Animation<Color> colorLightGreenToGreen;
  List<Animation> animationStages = [];

  int get currentColorStage {
    _currentColorStage = _calculateAnimationStage(widget.controller.value);
    return _currentColorStage;
  }

  int get numberOfColorStages {
    _numberOfColorStages = _calculateNumberOfColorTransitionStages(widget.targetRating);
    return _numberOfColorStages;
  }


  @override
  void initState() {
    super.initState();
    _currentColorStage = 0;
    singleColorStageControllerValueInterval = (numberOfColorStages > 0) ? 1.0 / numberOfColorStages : 1.0;
    _initAnimations();
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Opacity(
      opacity: starsOpacity.value,
      child: Stack(
        children: <Widget>[
          CustomPaint(
            painter: StarsPainter(
                targetPercent: 100,
                currentPercent: 100,
                color: Color(0xFFEBEBEB)),
            child: SizedBox(width: starsWidth),
          ),
          CustomPaint(
            painter: StarsPainter(
                targetPercent: 100,
                currentPercent: starsPercent.value,
                color: animationStages[currentColorStage].value),
            child: SizedBox(width: starsWidth),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: widget.controller,
    );
  }

  int _calculateNumberOfColorTransitionStages(double rating) {
    if (rating >= 7.5) {
      return 4; // Red -> Orange, Orange -> Yellow, Yellow -> Light Green, Light Green -> Green
    } else if (rating >= 6.5) {
      return 3; // Red -> Orange, Orange -> Yellow, Yellow -> Light Green
    } else if (rating >= 5.5) {
      return 2; // Red -> Orange, Orange -> Yellow
    } else if (rating >= 4.5) {
      return 1; // Red -> Orange
    } else {
      return 0; // Red -> Red?
    }
  }

  int _calculateAnimationStage(double controllerValue) {
    if (numberOfColorStages == 0 && controllerValue <= singleColorStageControllerValueInterval) {
      return 0;
    } else if (numberOfColorStages > 0 && controllerValue <= singleColorStageControllerValueInterval) {
      return 1;
    } else if (numberOfColorStages > 1 && controllerValue <= singleColorStageControllerValueInterval * 2) {
      return 2;
    } else if (numberOfColorStages > 2 && controllerValue <= singleColorStageControllerValueInterval * 3) {
      return 3;
    } else if (numberOfColorStages > 3 && controllerValue <= singleColorStageControllerValueInterval * 4) {
      return 4;
    } else {
      return _currentColorStage;
    }
  }

  void _initAnimations() {
    starsPercent = Tween(
      begin: 0.0,
      end: widget.targetRating * 10,
    ).animate(CurvedAnimation(
      parent: widget.controller,
      curve: Interval(
        0.65,
        1.0,
        curve: Curves.linear,
      ),
    ));

    starsOpacity = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: widget.controller,
        curve: Interval(
          0.0,
          0.55,
          curve: Curves.easeIn,
        ),
    ));

    animationStages.add(colorRed = ConstantTween(AppColors.red).animate(widget.controller));

    void initRedToOrange() => animationStages.add(colorRedToOrange = ColorTween(
      begin: AppColors.red,
      end: AppColors.orange,
    ).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Interval(
          0.0,
          singleColorStageControllerValueInterval,
          curve: Curves.easeInCubic,
        ),
      ),
    ));

    void initOrangeToYellow() => animationStages.add(colorOrangeToYellow = ColorTween(
      begin: AppColors.orange,
      end: AppColors.yellow,
    ).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Interval(
          singleColorStageControllerValueInterval,
          singleColorStageControllerValueInterval * 2,
          curve: Curves.easeInCubic,
        ),
      ),
    ));

    void initYellowToLightGreen() => animationStages.add(colorYellowToLightGreen = ColorTween(
      begin: AppColors.yellow,
      end: AppColors.lightGreen,
    ).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Interval(
          singleColorStageControllerValueInterval * 2,
          singleColorStageControllerValueInterval * 3,
          curve: Curves.easeInCubic,
        ),
      ),
    ));

    void initLightGreenToGreen() => animationStages.add(colorLightGreenToGreen = ColorTween(
      begin: AppColors.lightGreen,
      end: AppColors.green,
    ).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Interval(
          singleColorStageControllerValueInterval * 3,
          singleColorStageControllerValueInterval * 4,
          curve: Curves.easeInCubic,
        ),
      ),
    ));

    switch (numberOfColorStages) {
      case 0:
        break;
      case 1:
        initRedToOrange();
        break;
      case 2:
        initRedToOrange();
        initOrangeToYellow();
        break;
      case 3:
        initRedToOrange();
        initOrangeToYellow();
        initYellowToLightGreen();
        break;
      case 4:
        initRedToOrange();
        initOrangeToYellow();
        initYellowToLightGreen();
        initLightGreenToGreen();
    }
  }
}
