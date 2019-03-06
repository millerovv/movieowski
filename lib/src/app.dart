import 'package:flutter/material.dart';
import 'package:movieowski/src/blocs/base/bloc_provider.dart';
import 'package:movieowski/src/blocs/popular_movies/bloc_popular_movies.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';
import 'package:movieowski/src/ui/pages/popular_movies_page.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

/// Base application class
class Movieowski extends StatelessWidget {
  final MoviesRepository _moviesRepository;

  Movieowski(this._moviesRepository) : assert(_moviesRepository != null);

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      FlutterStatusbarcolor.setStatusBarColor(Color(0xFF081B24));
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    }
    return MaterialApp(
      title: 'Movieowski',
      theme: ThemeData(
        primaryColor: Color(0xFF081B24),
        primaryColorDark: Color(0xFF081B24),
        accentColor: Color(0xFF06D177),
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xE6FFFFFF)),
        )
      ),
      home: BlocProvider<PopularMoviesBloc>(
        bloc: PopularMoviesBloc(moviesRepository: _moviesRepository),
        child: HomePage(),
      ),
    );
  }

}
