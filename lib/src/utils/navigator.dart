import 'package:flutter/material.dart';
import 'package:movieowski/src/model/api/response/base_movies_response.dart';
import 'package:movieowski/src/ui/movie_details_page.dart';

goToMovieDetails(BuildContext context, Movie movie, String heroTag) {
	_pushWidgetWithFade(context, MovieDetailsPage(movie: movie, heroTag: heroTag));
}

_pushWidgetWithFade(BuildContext context, Widget widget) {
	Navigator.of(context).push(
		PageRouteBuilder(

				transitionsBuilder:
						(context, animation, secondaryAnimation, child) =>
						FadeTransition(opacity: animation, child: child),

				pageBuilder: (BuildContext context, Animation animation,
						Animation secondaryAnimation) {
					return widget;
				}),
	);
}