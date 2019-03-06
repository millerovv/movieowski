import 'package:movieowski/src/models/popular_movie_model.dart';
import 'dart:async';

import 'package:movieowski/src/utils/consts.dart';

class MoviesRepository {
	final tmdpApiProvider;

	MoviesRepository(this.tmdpApiProvider) : assert(tmdpApiProvider != null);

	Future<PopularMoviesModel> fetchPopularMovies(
			{int pageIndex: 1,
				String language: Languages.ENGLISH,
				String region: Regions.RUSSIA}) =>
			tmdpApiProvider.getPopularMovies(pageIndex: pageIndex, language: language, region: region);
}