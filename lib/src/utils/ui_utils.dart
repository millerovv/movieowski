import 'package:flutter/material.dart';
import 'package:movieowski/src/utils/consts.dart';
import 'package:shimmer/shimmer.dart';

/// Get color for rating circle depending on rating value
Color calculateRatingColor(double rating) {
  if (rating >= 7.5) {
    return AppColors.green;
  } else if (rating >= 6.5) {
    return AppColors.lightGreen;
  } else if (rating >= 5.5) {
    return AppColors.yellow;
  } else if (rating >= 4.5) {
    return AppColors.orange;
  } else if (rating != 0.0) {
    return AppColors.red;
  } else {
    return AppColors.hintGrey;
  }
}

Widget shimmer(Widget child, [int durationMills = 1500]) {
  return Shimmer.fromColors(
    baseColor: AppColors.lighterPrimary,
    highlightColor: Colors.grey,
    period: Duration(milliseconds: durationMills),
    child: child,
  );
}

Widget heroWidget(bool withHero, String tag, Widget child) {
  return withHero
      ? Material(
          color: Colors.transparent,
          child: Hero(
            tag: tag,
            child: child,
          ),
        )
      : child;
}
