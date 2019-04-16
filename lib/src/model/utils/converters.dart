import 'package:movieowski/src/model/api/response/base_movies_response.dart';
import 'package:movieowski/src/model/api/response/person_details_response.dart';

Movie convertCastToMovie(Cast cast) => Movie(
      cast.id,
      cast.title,
      cast.posterPath,
      cast.voteAverage,
      cast.voteCount,
      cast.releaseDate,
      cast.genreIds,
      cast.adult,
      cast.popularity,
      cast.overview,
      cast.originalTitle,
      cast.originalLanguage,
      cast.backdropPath,
      cast.video,
    );

Movie convertCrewToMovie(Crew crew) => Movie(
      crew.id,
      crew.title,
      crew.posterPath,
      crew.voteAverage,
      crew.voteCount,
      crew.releaseDate,
      crew.genreIds,
      crew.adult,
      crew.popularity,
      crew.overview,
      crew.originalTitle,
      crew.originalLanguage,
      crew.backdropPath,
      crew.video,
);
