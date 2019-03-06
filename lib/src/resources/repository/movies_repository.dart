import 'package:movieowski/src/models/now_playing_movies_response.dart';
import 'package:movieowski/src/models/popular_movies_response.dart';
import 'dart:async';

import 'package:movieowski/src/utils/consts.dart';

class MoviesRepository {
  final tmdpApiProvider;

  MoviesRepository(this.tmdpApiProvider) : assert(tmdpApiProvider != null);

  Future<PopularMoviesResponseRoot> fetchPopularMovies(
          {int pageIndex: 1, String language: Languages.ENGLISH, String region: Regions.RUSSIA}) =>
      tmdpApiProvider.getPopularMovies(pageIndex: pageIndex, language: language, region: region);

  Future<NowPlayingMoviesResponseRoot> fetchNowPlayingMovies(
          {int pageIndex: 1, String language: Languages.ENGLISH, String region: Regions.RUSSIA}) =>
      tmdpApiProvider.getNowPlayingMovies(pageIndex: pageIndex, language: language, region: region);
}
