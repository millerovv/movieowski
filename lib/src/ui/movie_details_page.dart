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
        body: PageView(
          controller: pageController,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            GestureDetector(
              onTap: () => pageController.animateToPage(1, duration: Duration(milliseconds: 800), curve: Curves.easeInOut),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.network(TmdbApiProvider.BASE_IMAGE_URL_ORIGINAL + widget.movie.posterPath),
                ],
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
