import 'package:flutter/material.dart';
import 'package:movieowski/src/utils/consts.dart';

class AnimatedAppbarBackground extends StatelessWidget {
  final AnimationController controller;
  final Animation<double> appBarHeight;

  AnimatedAppbarBackground({Key key, this.controller})
      : appBarHeight = Tween<double>(
          begin: 0,
          end: kToolbarHeight + kStatusBarHeight, //Toolbar height + Status bar height
        ).animate(CurvedAnimation(parent: controller, curve: Interval(0.0, 0.8, curve: Curves.easeIn))),

        super(key: key);

  Widget _buildAnimatedAppbarBackground(BuildContext context, Widget child) {
      return PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight.value),
        child: Container(
          height: appBarHeight.value,
          width: MediaQuery.of(context).size.width,

          decoration: controller.value >= 0.8 ? BoxDecoration(
              color: Theme.of(context).primaryColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                offset: Offset(1.0, 1.0),
                blurRadius: 2.0,
              )
            ]
          ) : BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: _buildAnimatedAppbarBackground,
    );
  }
}
