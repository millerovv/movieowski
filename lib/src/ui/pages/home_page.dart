import 'package:flutter/material.dart';
import 'package:movieowski/src/blocs/base/bloc_provider.dart';
import 'package:movieowski/src/blocs/home_page/bloc_now_playing_movies_section.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';
import 'package:movieowski/src/ui/now_playing_movies_section.dart';
import 'package:movieowski/src/utils/consts.dart';

class HomePage extends StatefulWidget {
  final MoviesRepository _moviesRepository;

  HomePage(this._moviesRepository) : assert(_moviesRepository != null);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _forAndroid;

  @override
  Widget build(BuildContext context) {
    _forAndroid = Theme.of(context).platform == TargetPlatform.android;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            new SliverAppBar(
              flexibleSpace: _createSearchBar(),
              floating: _forAndroid,
              snap: _forAndroid,
              pinned: !_forAndroid,
            ),
          ];
        },
        body: BlocProvider<NowPlayingMoviesSectionBloc>(
          bloc: NowPlayingMoviesSectionBloc(widget._moviesRepository),
          child: MoviesSection(),
        ),
      ),
    ));
  }

  Widget _createSearchBar() {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Container(
          margin: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: _forAndroid ? AppColors.primaryWhite : AppColors.lighterPrimary,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            boxShadow: _forAndroid
                ? <BoxShadow>[
                    BoxShadow(
                      color: Colors.black87,
                      offset: Offset(1.0, 1.0),
                      blurRadius: 4.0,
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Icon(
                    Icons.search,
                    color: _forAndroid ? AppColors.hintGrey : AppColors.hintWhite,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Search for any movie or actor',
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: _forAndroid ? AppColors.hintGrey : AppColors.hintWhite),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
