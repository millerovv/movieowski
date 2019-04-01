import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movieowski/src/blocs/movie_details_page/movie_details_page_bloc_export.dart';
import 'package:movieowski/src/model/api/response/base_movies_response.dart';
import 'package:movieowski/src/resources/api/tmdp_api_provider.dart';
import 'package:movieowski/src/utils/consts.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;
  final String heroTag;

  MovieDetailsPage({Key key, this.movie, this.heroTag}) : super(key: key);

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  MovieDetailsPageBloc _bloc;
  PageController pageController;

  double gradientHeight = 0;
  Timer _gradientTimer;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    _gradientTimer = Timer(const Duration(milliseconds: 100), () {
      setState(() {
        gradientHeight = 320.0;
      });
    });
  }

  @override
  void dispose() {
    _bloc?.dispose();
    _gradientTimer?.cancel();
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
              onTap: () =>
                  pageController.animateToPage(1, duration: Duration(milliseconds: 1000), curve: Curves.easeInOut),
              child: LayoutBuilder(
                builder: (context, constraints) => Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topCenter,
                          child: Hero(
                            tag: widget.heroTag,
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              child: Image.network(
                                TmdbApiProvider.BASE_IMAGE_URL_W500 + widget.movie.posterPath,
                                alignment: Alignment.topCenter,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: AnimatedContainer(
                            height: gradientHeight,
                            duration: Duration(milliseconds: 400),
                            width: double.infinity,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                colors: <Color>[
                                  Colors.transparent,
                                  AppColors.primaryColorHalfTransparent,
                                  AppColors.primaryColor,
                                ],
                              )),
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
