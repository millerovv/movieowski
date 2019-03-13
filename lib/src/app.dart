import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieowski/src/blocs/home_page/home_page_bloc.dart';
import 'package:movieowski/src/blocs/home_page/home_page_event.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';
import 'package:movieowski/src/ui/home_page.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:movieowski/src/utils/consts.dart';

/// Base application class
class Movieowski extends StatefulWidget {
  final MoviesRepository _moviesRepository;

  Movieowski(this._moviesRepository) : assert(_moviesRepository != null);

  @override
  _MovieowskiState createState() => _MovieowskiState();
}

class _MovieowskiState extends State<Movieowski> {
  HomePageBloc _homePageBloc;

  @override
  void initState() {
    _homePageBloc = HomePageBloc();
    _homePageBloc.dispatch(StartLoadingHomePage());
    super.initState();
  }

  @override
  void dispose() {
    _homePageBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      FlutterStatusbarcolor.setStatusBarColor(AppColors.primaryColor);
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    }
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Movieowski',
        theme: ThemeData(
            primaryColor: AppColors.primaryColor,
            primaryColorDark: AppColors.primaryColor,
            accentColor: AppColors.accentColor,
            textTheme: TextTheme(
              headline: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryWhite),
            )),
        home: BlocProvider<HomePageBloc>(
          bloc: _homePageBloc,
          child: HomePage(widget._moviesRepository),
        ));
  }
}
