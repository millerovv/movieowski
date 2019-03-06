import 'package:flutter/material.dart';
import 'package:movieowski/src/blocs/base/bloc_provider.dart';
import 'package:movieowski/src/blocs/popular_movies/bloc_popular_movies.dart';
import 'package:movieowski/src/ui/movie_card.dart';
import 'package:movieowski/src/utils/consts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PopularMoviesBloc _bloc;

  bool _forAndroid;

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<PopularMoviesBloc>(context);
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
          //TODO: delete hardcode
          body: _createInTheatersSection('/xRWht48C2V8XNfzvPehyClOvDni.jpg', 8.6),
        ),
      ),
    );
  }

  Widget _createInTheatersSection(String posterPath, double rating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0, left: 16.0, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text('In theaters', style: Theme.of(context).textTheme.headline),
              Text('See all',
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: MovieCard(posterPath, rating, _forAndroid),
        ),
      ],
    );
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
