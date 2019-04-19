import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieowski/src/blocs/home_page/genres/movie_genres_section_bloc_export.dart';
import 'package:movieowski/src/blocs/movie_details_page/movie_details_page_bloc_export.dart';
import 'package:movieowski/src/blocs/person_details_page/bloc_person_details_page.dart';
import 'package:movieowski/src/model/api/response/base_movies_response.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';
import 'package:movieowski/src/ui/details/movie/movie_details_page.dart';
import 'package:movieowski/src/ui/details/person/person_details_page.dart';
import 'package:movieowski/src/ui/see_all/see_all_movies_page.dart';

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
    int personId,
    String name,
    String profilePath,
    String posterHeroTag,
    ) {
  _pushWidgetWithDuration(
    context,
    BlocProvider<PersonDetailsPageBloc>(
      bloc: PersonDetailsPageBloc(repository, personId),
      child: PersonDetailsPage(
        personId: personId,
        profilePath: profilePath,
        name: name,
        posterHeroTag: posterHeroTag,
      ),
    ),
    movieDetailsTransitionDurationMills,
  );
}

goToSeeAllMovies(BuildContext context) {
  MovieGenresSectionBloc genresBloc = BlocProvider.of<MovieGenresSectionBloc>(context);
  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) =>
      BlocProvider(bloc: genresBloc, child: SeeAllMoviesPage(moviesType: SeeAllMoviesType.POPULAR_BY_CATEGORY))
  ));
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
