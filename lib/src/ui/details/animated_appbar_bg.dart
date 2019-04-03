import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedAppbarBackground extends StatelessWidget {
  final AnimationController controller;
  final Animation<double> appBarHeight;

  AnimatedAppbarBackground({Key key, this.controller})
      : appBarHeight = Tween<double>(
          begin: 0,
          end: kToolbarHeight,
        ).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn)),

        super(key: key);

  Widget _buildAnimatedAppbarBackground(BuildContext context, Widget child) {
    return Transform.rotate(
      angle: math.pi,
      child: Card(
        margin: EdgeInsets.all(0.0),
        elevation: 3,
        child: Container(
          height: appBarHeight.value,
          width: MediaQuery.of(context).size.width,
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
