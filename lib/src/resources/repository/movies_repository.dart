import 'dart:async';

import 'package:movieowski/src/model/api/response/movie_genres_response.dart';
import 'package:movieowski/src/model/api/response/now_playing_movies_response.dart';
import 'package:movieowski/src/model/api/response/person_details_response.dart';
import 'package:movieowski/src/model/api/response/trending_movies_response.dart';
import 'package:movieowski/src/model/api/response/upcoming_movies_response.dart';
import 'package:movieowski/src/resources/api/tmdp_api_provider.dart';
import 'package:movieowski/src/resources/persistance/database.dart';
import 'package:movieowski/src/utils/consts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoviesRepository {
  static const String spLastGenreUpdateDateKey = 'spLastGenreUpdateDateKey';
  final TmdbApiProvider tmdpApiProvider;

  MoviesRepository(this.tmdpApiProvider) : assert(tmdpApiProvider != null);

  Future<TrendingMoviesResponseRoot> fetchTrendingMovies() => tmdpApiProvider.getTrendingMovies();

  Future<NowPlayingMoviesResponseRoot> fetchNowPlayingMovies(
          {int pageIndex: 1, String language: Languages.english, String region: Regions.usa}) =>
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
      {int pageIndex: 1, String language: Languages.english, String region: Regions.usa}) =>
      tmdpApiProvider.getUpcomingMovies(pageIndex: pageIndex, language: language, region: region);

  /// Fetching genres based on date of last genres list upload from the tmdb api.
  /// If 14 days have passed since last upload from api or there are no genres in local DB, make new request.
  /// Fetch genres from database otherwise
  Future<List<Genre>> fetchMovieGenres({String language: Languages.english}) async {
    List<Genre> genresFromDb = await DBProvider.dbProvider.getAllGenres();
    DateTime lastGenresFetchFromApiDate = await getLastGenresFetchFromApiDate();
    bool updateNeeded = _needToUpdateGenresBasedOnDate(lastGenresFetchFromApiDate);
    if (genresFromDb.isNotEmpty && !updateNeeded) {
      return genresFromDb;
    } else {
      final List<Genre> genresFromApi = (await tmdpApiProvider.getMovieGenresList(language: language)).genres;
      saveLastGenresFetchFromApiDate(DateTime.now());
      // Delete all previous genres from db if we want to replace old values from previous fetch,
      // because tmdb could change genre id's and we'll have redundant doubling values
      if (genresFromDb.isNotEmpty) {
        await DBProvider.dbProvider.deleteAllGenres();
      }
      DBProvider.dbProvider.insertGenres(genresFromApi);
      return genresFromApi;
    }
  }

  Future<DateTime> getLastGenresFetchFromApiDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int dateMills = prefs.getInt(spLastGenreUpdateDateKey);
    return (dateMills != null) ? DateTime.fromMillisecondsSinceEpoch(dateMills) : DateTime(1);
  }

  Future<void> saveLastGenresFetchFromApiDate(DateTime date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(spLastGenreUpdateDateKey, date.millisecondsSinceEpoch);
  }

  _needToUpdateGenresBasedOnDate(DateTime lastFetch) {
    var difference = lastFetch.difference(DateTime.now());
    return difference.inDays >= 14;
  }
}

