import 'dart:convert';

import 'package:movieowski/src/model/api/response/movie_genres_response.dart';
import 'package:movieowski/src/model/api/response/person_details_response.dart';
import 'package:movieowski/src/model/api/response/popular_people_response.dart';
import 'package:movieowski/src/model/api/response/trending_movies_response.dart';
import 'package:movieowski/src/model/api/response/now_playing_movies_response.dart';
import 'package:movieowski/src/model/api/response/upcoming_movies_response.dart';
import 'package:movieowski/src/resources/api/base_api_provider.dart';
import 'dart:async';

import 'package:movieowski/src/utils/consts.dart';

class TmdbApiProvider extends BaseApiProvider {
  static const String BASE_URL = 'api.themoviedb.org';
  static const String BASE_IMAGE_URL_W300 = 'http://image.tmdb.org/t/p/w300';
  static const String BASE_IMAGE_URL_ORIGINAL = 'http://image.tmdb.org/t/p/original';
  static const String API_KEY = 'f31e1ed88bfb5a83cc3270aafe460be4';

  //TODO: Maybe should replace this request with /movies/popular
  /// Request list of trending movies
  /// Documentation: https://developers.themoviedb.org/3/trending/get-trending
  Future<TrendingMoviesResponseRoot> getTrendingMovies() async {
    var url = Uri.https(
      BASE_URL,
      '3/trending/movie/week',
      <String, String>{
        'api_key': API_KEY,
      },
    );

    var response = await getRequest(url);
    final TrendingMoviesResponseRoot movies = TrendingMoviesResponseRoot.fromJson(json.decode(response));
    return movies;
  }

  /// Request list of movies playing in theatres now
  /// Documentation: https://developers.themoviedb.org/3/movies/get-now-playing
  Future<NowPlayingMoviesResponseRoot> getNowPlayingMovies(
      {int pageIndex: 1, String language: Languages.english, String region: Regions.usa}) async {
    var url = Uri.https(
      BASE_URL,
      '3/movie/now_playing',
      <String, String>{
        'api_key': API_KEY,
        'page': '$pageIndex',
        'language': language,
        'region': region,
      },
    );

    var response = await getRequest(url);
    final NowPlayingMoviesResponseRoot movies = NowPlayingMoviesResponseRoot.fromJson(json.decode(response));
    return movies;
  }

  /// Request list of trending actors
  /// Documentation: https://developers.themoviedb.org/3/people/get-popular-people
  Future<PopularPeopleResponseRoot> getPopularPeople() async {
    var url = Uri.https(
      BASE_URL,
      '3/person/popular',
      <String, String>{
        'api_key': API_KEY,
      },
    );

    var response = await getRequest(url);
    final PopularPeopleResponseRoot actors = PopularPeopleResponseRoot.fromJson(json.decode(response));
    return actors;
  }

  /// Request person detailed information by id
  /// Documentation: https://developers.themoviedb.org/3/people/get-person-details
  Future<PersonDetailsResponseRoot> getPersonDetails({int personId, language: Languages.english}) async {
    var url = Uri.https(
      BASE_URL,
      '3/person/$personId',
      <String, String>{
        'api_key': API_KEY,
        'language': language,
      },
    );

    var response = await getRequest(url);
    final PersonDetailsResponseRoot details = PersonDetailsResponseRoot.fromJson(json.decode(response));
    return details;
  }

  /// Request list of upcoming movies
  /// Documentation: https://developers.themoviedb.org/3/movies/get-upcoming
  Future<UpcomingMoviesResponseRoot> getUpcomingMovies(
      {int pageIndex: 1, String language: Languages.english, String region: Regions.usa}) async {
    var url = Uri.https(
      BASE_URL,
      '3/movie/upcoming',
      <String, String>{
        'api_key': API_KEY,
        'page': '$pageIndex',
        'language': language,
        'region': region,
      },
    );

    var response = await getRequest(url);
    final UpcomingMoviesResponseRoot movies = UpcomingMoviesResponseRoot.fromJson(json.decode(response));
    return movies;
  }

  /// Request the list of official genres for movies
  /// Documentation: https://developers.themoviedb.org/3/genres/get-movie-list
  Future<MovieGenresResponseRoot> getMovieGenresList({String language: Languages.english}) async {
    var url = Uri.https(
      BASE_URL,
      '3/genre/movie/list',
      <String, String>{
        'api_key': API_KEY,
        'language': language,
      },
    );

    var response = await getRequest(url);
    final MovieGenresResponseRoot genres = MovieGenresResponseRoot.fromJson(json.decode(response));
    return genres;
  }
}
