import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieowski/src/blocs/movie_details_page/movie_details_page_bloc_export.dart';
import 'package:movieowski/src/model/api/response/base_movies_response.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';
import 'package:movieowski/src/ui/details/movie_details_page.dart';

const int movieDetailsTransitionDurationMills = 500;

goToMovieDetails(
  BuildContext context,
  MoviesRepository repository,
  Movie movie,
  String imageHeroTag,
  String ratingHeroTag,
) {
  _pushWidgetWithFade(
    context,
    BlocProvider<MovieDetailsPageBloc>(
      bloc: MovieDetailsPageBloc(repository, movie.id),
      child: MovieDetailsPage(
        movie: movie,
        posterHeroTag: imageHeroTag,
        numberRatingHeroTag: ratingHeroTag,
      ),
    ),
    movieDetailsTransitionDurationMills,
  );
}

_pushWidgetWithFade(BuildContext context, Widget widget, int durationMills) {
//  Navigator.push(
//    context,
//    MaterialPageRoute(builder: (context) => widget),
//  );
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
