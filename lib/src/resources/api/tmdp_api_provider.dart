import 'dart:convert';

import 'package:movieowski/src/models/now_playing_movies_response.dart';
import 'package:movieowski/src/models/trending_movies_response.dart';
import 'package:movieowski/src/resources/api/base_api_provider.dart';
import 'dart:async';

import 'package:movieowski/src/utils/consts.dart';

class TmdbApiProvider extends BaseApiProvider {
  static const String BASE_URL = 'api.themoviedb.org';
  static const String BASE_IMAGE_URL = 'http://image.tmdb.org/t/p/w300';
  static const String API_KEY = 'f31e1ed88bfb5a83cc3270aafe460be4';

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
      {int pageIndex: 1, String language: Languages.ENGLISH, String region: Regions.RUSSIA}) async {
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
}
