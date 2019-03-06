import 'package:flutter/material.dart';
import 'package:movieowski/src/blocs/base/bloc_provider.dart';
import 'package:movieowski/src/blocs/popular_movies/bloc_popular_movies.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PopularMoviesBloc bloc;

  bool isAndroid;

  @override
  void dispose() {
    bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<PopularMoviesBloc>(context);
    isAndroid = Theme.of(context).platform == TargetPlatform.android;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF081B24),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                flexibleSpace: _createSearchBar(),
                floating: isAndroid,
                snap: isAndroid,
                pinned: !isAndroid,
              ),
            ];
          },
          body: Container(
            child: Padding(
              padding: EdgeInsets.only(top: 12.0, left: 16.0),
              child: Text('In theaters', style: Theme.of(context).textTheme.headline),
            ),
          ),
        ),
      ),
    );
  }

  Widget _createSearchBar() {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Container(
          margin: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: isAndroid ? Color(0xE6FFFFFF) : Color(0xFF042F43),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            boxShadow: isAndroid
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
                    color: Color(0xFFA7A7A7),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Search for any movie or actor',
                    style: Theme.of(context).textTheme.caption.copyWith(color: Color(0xFF686868)),
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
