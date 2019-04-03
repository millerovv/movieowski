import 'package:flutter/material.dart';
import 'package:movieowski/src/model/api/response/base_movies_response.dart';
import 'package:movieowski/src/ui/details/movie_details_page.dart';

const int movieDetailsTransitionDurationMills = 500;

goToMovieDetails(BuildContext context, Movie movie, String imageHeroTag, String ratingHeroTag) {
  _pushWidgetWithFade(
    context,
    MovieDetailsPage(
      movie: movie,
      posterHeroTag: imageHeroTag,
      numberRatingHeroTag: ratingHeroTag,
    ),
    movieDetailsTransitionDurationMills,
  );
}

_pushWidgetWithFade(BuildContext context, Widget widget, int durationMills) {
  Navigator.of(context).push(
    PageRouteBuilder(
        transitionDuration:
            (durationMills != null) ? Duration(milliseconds: durationMills) : const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
        pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
          return widget;
        }),
  );
}
