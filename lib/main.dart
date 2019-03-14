import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:movieowski/src/app.dart';
import 'package:movieowski/src/resources/api/tmdp_api_provider.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';
import 'package:movieowski/src/utils/logger.dart';

void main() {
	final TmdbApiProvider tmdbApiProvider = TmdbApiProvider();
	final MoviesRepository moviesRepository = MoviesRepository(tmdbApiProvider);

	BlocSupervisor().delegate = SimpleBlocDelegate();

	runApp(Movieowski(moviesRepository));
}

class SimpleBlocDelegate extends BlocDelegate {
	@override
	onTransition(Transition transition) {
		Log.d(transition.toString(), 'Bloc_Transition');
	}

	@override
	void onError(Object error, StackTrace stacktrace) {
		Log.e(error, stacktrace);
	}
}