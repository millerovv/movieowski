import 'dart:async';

import 'package:movieowski/src/model/api/response/now_playing_movies_response.dart';
import 'package:movieowski/src/model/api/response/person_details_response.dart';
import 'package:movieowski/src/model/api/response/trending_movies_response.dart';
import 'package:movieowski/src/resources/api/tmdp_api_provider.dart';
import 'package:movieowski/src/utils/consts.dart';

class MoviesRepository {
  final TmdbApiProvider tmdpApiProvider;

  MoviesRepository(this.tmdpApiProvider) : assert(tmdpApiProvider != null);

  Future<TrendingMoviesResponseRoot> fetchTrendingMovies() => tmdpApiProvider.getTrendingMovies();

  Future<NowPlayingMoviesResponseRoot> fetchNowPlayingMovies(
          {int pageIndex: 1, String language: Languages.ENGLISH, String region: Regions.RUSSIA}) =>
      tmdpApiProvider.getNowPlayingMovies(pageIndex: pageIndex, language: language, region: region);

  List<PersonDetailsResponse> fetchTrendingActorsWithDetails() {
     List<Future<PersonDetailsResponse>> personDetailsFutures = [];
     List<PersonDetailsResponse> personDetails = [];
     tmdpApiProvider.getPopularPeople().then((people) => people.results.forEach(
             (person) => personDetailsFutures.add(tmdpApiProvider.getPersonDetails(personId: person.id))));
     Future.wait(personDetailsFutures).then((values) => personDetails = values);
     return personDetails;
  }
}
