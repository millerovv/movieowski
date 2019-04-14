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
            transitionOnUserGestures: true,
            child: child,
          ),
        )
      : child;
}

Widget createBasicTitleSubtitleSection(BuildContext context, String title, String subtitle) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      (title.isNotEmpty && subtitle.isNotEmpty) ? Padding(
        padding: EdgeInsets.only(left: 16.0, top: 16.0),
        child: Text(
          title,
          style:
          Theme.of(context).textTheme.body1.copyWith(color: AppColors.primaryWhite, fontWeight: FontWeight.bold),
        ),
      ) : SizedBox(),
      (subtitle.isNotEmpty) ? Padding(
        padding: EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0),
        child: Text(
          subtitle,
          style: Theme.of(context).textTheme.caption.copyWith(color: AppColors.primaryWhite),
        ),
      ) : SizedBox(),
    ],
  );
}

/// Behavior used to disable scrollable views vertical borders glow
class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}