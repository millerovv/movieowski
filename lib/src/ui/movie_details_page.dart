import 'package:flutter/material.dart';
import 'package:movieowski/src/blocs/movie_details_page/movie_details_page_bloc_export.dart';
import 'package:movieowski/src/model/api/response/base_movies_response.dart';
import 'package:movieowski/src/resources/api/tmdp_api_provider.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;

  MovieDetailsPage(this.movie);

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  MovieDetailsPageBloc _bloc;
  PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: PageView(
          controller: pageController,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            GestureDetector(
              onTap: () => pageController.animateToPage(1, duration: Duration(milliseconds: 800), curve: Curves.easeInOut),
              child: LayoutBuilder(
                builder: (context, constraints) => Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: Hero(
                        tag: widget.movie.posterPath,
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          child: Image.network(
                            TmdbApiProvider.BASE_IMAGE_URL_W500 + widget.movie.posterPath,
                            alignment: Alignment.topCenter,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.pink,
            ),
          ],
        ),
      ),
    );
  }
}
