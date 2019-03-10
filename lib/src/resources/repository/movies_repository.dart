import 'dart:async';

import 'package:movieowski/src/model/api/response/movie_genres_response.dart';
import 'package:movieowski/src/model/api/response/now_playing_movies_response.dart';
import 'package:movieowski/src/model/api/response/person_details_response.dart';
import 'package:movieowski/src/model/api/response/trending_movies_response.dart';
import 'package:movieowski/src/model/api/response/upcoming_movies_response.dart';
import 'package:movieowski/src/resources/api/tmdp_api_provider.dart';
import 'package:movieowski/src/utils/consts.dart';

class MoviesRepository {
  final TmdbApiProvider tmdpApiProvider;

  MoviesRepository(this.tmdpApiProvider) : assert(tmdpApiProvider != null);

  Future<TrendingMoviesResponseRoot> fetchTrendingMovies() => tmdpApiProvider.getTrendingMovies();

  Future<NowPlayingMoviesResponseRoot> fetchNowPlayingMovies(
          {int pageIndex: 1, String language: Languages.ENGLISH, String region: Regions.USA}) =>
      tmdpApiProvider.getNowPlayingMovies(pageIndex: pageIndex, language: language, region: region);

  /// Chained API request. Firstly we get list of popular people Ids, then for each Id
  /// we request additional details about this person
  Future<List<PersonDetailsResponseRoot>> fetchPopularActorsWithDetails() async {
    List<int> peopleIds = (await tmdpApiProvider.getPopularPeople())
        .results
        .map((p) => p.id)
        .toList();
    List<PersonDetailsResponseRoot> peopleDetails = await Future.wait(peopleIds
            .map((id) => tmdpApiProvider.getPersonDetails(personId: id))
            .toList());
     return peopleDetails;
  }

  Future<UpcomingMoviesResponseRoot> fetchUpcomingMovies(
      {int pageIndex: 1, String language: Languages.ENGLISH, String region: Regions.USA}) =>
      tmdpApiProvider.getUpcomingMovies(pageIndex: pageIndex, language: language, region: region);

  Future<MovieGenresResponseRoot> fetchMovieGenres({String language: Languages.ENGLISH}) =>
      tmdpApiProvider.getMovieGenresList(language: language);
}
