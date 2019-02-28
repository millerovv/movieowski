import 'package:movieowski/src/models/popular_movie_model.dart';
import 'package:movieowski/src/resources/api/tmdp_api_provider.dart';
import 'package:movieowski/src/utils/AppConfigLoader.dart';
import 'dart:async';

class MoviesRepository {
	final tmdpApiProvider = TmdbApiProvider(AppConfigLoader());

	Future<PopularMoviesModel> fetchPopularMovies(
			{int pageIndex: 1, String language: 'en-US', String region: 'RU'}) =>
			tmdpApiProvider.getPopularMovies(pageIndex: pageIndex, language: language, region: region);
}