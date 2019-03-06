import 'dart:convert';

import 'package:movieowski/src/models/popular_movie_model.dart';
import 'package:movieowski/src/resources/api/base_api_provider.dart';
import 'package:movieowski/src/utils/app_config_loader.dart';
import 'dart:async';

import 'package:movieowski/src/utils/consts.dart';

class TmdbApiProvider extends BaseApiProvider {
  static const String BASE_URL = 'api.themoviedb.org';
  static const String BASE_IMAGE_URL = 'http://image.tmdb.org/t/p/w300';
  String apiKey;

  TmdbApiProvider(AppConfigLoader loader) {
    loader.load().then((value) => {apiKey = value.tmdbApiKey});
  }

  /// Request list of popular movies
  /// Documentation: https://developers.themoviedb.org/3/movies/get-popular-movies
  Future<PopularMoviesModel> getPopularMovies(
      {int pageIndex: 1, String language: Languages.ENGLISH, String region: Regions.RUSSIA}) async {
    var url = Uri.https(
      BASE_URL,
      '3/movie/popular',
      <String, String>{
        'api_key': apiKey,
        'page': '$pageIndex',
        'language': language,
        'region': region,
      },
    );

    var response = await getRequest(url);
    final PopularMoviesModel movies =
        PopularMoviesModel.fromJson(json.decode(response));
    return movies;
  }
}
