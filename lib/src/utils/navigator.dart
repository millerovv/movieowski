import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieowski/src/blocs/movie_details_page/movie_details_page_bloc_export.dart';
import 'package:movieowski/src/blocs/person_details_page/bloc_person_details_page.dart';
import 'package:movieowski/src/model/api/response/base_movies_response.dart';
import 'package:movieowski/src/model/api/response/popular_people_response.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';
import 'package:movieowski/src/ui/details/movie/movie_details_page.dart';
import 'package:movieowski/src/ui/details/person/person_details_page.dart';

const int movieDetailsTransitionDurationMills = 500;

goToMovieDetails(
  BuildContext context,
  MoviesRepository repository,
  Movie movie,
  String imageHeroTag,
  String ratingHeroTag,
) {
  _pushWidgetWithDuration(
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

goToPersonDetails(
    BuildContext context,
    MoviesRepository repository,
    Person person,
    String posterHeroTag,
    ) {
  _pushWidgetWithDuration(
    context,
    BlocProvider<PersonDetailsPageBloc>(
      bloc: PersonDetailsPageBloc(repository, person.id),
      child: PersonDetailsPage(
        person: person,
        posterHeroTag: posterHeroTag,
      ),
    ),
    movieDetailsTransitionDurationMills,
  );
}

void _pushWidgetWithDuration(BuildContext context, Widget widget, int durationMills) {
  Navigator.of(context).push(
    CustomDurationMaterialPageRoute(builder: (context) => widget, durationMills: durationMills),
  );
}

void _pushWidgetWithFade(BuildContext context, Widget widget, int durationMills) {
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

class CustomDurationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  final int durationMills;

  CustomDurationMaterialPageRoute({
    @required builder,
    this.durationMills = 300,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  })  : assert(builder != null),
        assert(maintainState != null),
        assert(fullscreenDialog != null),
        assert(durationMills != null),
        super(builder: builder, settings: settings, maintainState: maintainState, fullscreenDialog: fullscreenDialog);

  @override
  Duration get transitionDuration => Duration(milliseconds: durationMills);
}
