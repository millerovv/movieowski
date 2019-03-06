import 'package:flutter/material.dart';
import 'package:movieowski/src/app.dart';
import 'package:movieowski/src/resources/api/tmdp_api_provider.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';
import 'package:movieowski/src/utils/app_config_loader.dart';

void main() {
	final AppConfigLoader appConfigLoader = AppConfigLoader('assets/app_config.json');
	final TmdbApiProvider tmdbApiProvider = TmdbApiProvider(appConfigLoader);
	final MoviesRepository moviesRepository = MoviesRepository(tmdbApiProvider);

	runApp(Movieowski(moviesRepository));
}

