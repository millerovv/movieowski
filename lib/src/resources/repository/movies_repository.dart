import 'package:movieowski/src/models/popular_movie_model.dart';
import 'package:movieowski/src/resources/api/tmdp_api_provider.dart';
import 'package:movieowski/src/utils/app_config_loader.dart';
import 'dart:async';

import 'package:movieowski/src/utils/consts.dart';

class MoviesRepository {
	final tmdpApiProvider = TmdbApiProvider(AppConfigLoader());

	Future<PopularMoviesModel> fetchPopularMovies(
			{int pageIndex: 1,
				String language: Languages.ENGLISH,
				String region: Regions.RUSSIA}) =>
			tmdpApiProvider.getPopularMovies(pageIndex: pageIndex, language: language, region: region);
}