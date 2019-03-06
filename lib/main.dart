import 'package:flutter/material.dart';
import 'package:movieowski/src/app.dart';
import 'package:movieowski/src/resources/api/tmdp_api_provider.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';

void main() {
	final TmdbApiProvider tmdbApiProvider = TmdbApiProvider();
	final MoviesRepository moviesRepository = MoviesRepository(tmdbApiProvider);

	runApp(Movieowski(moviesRepository));
}

