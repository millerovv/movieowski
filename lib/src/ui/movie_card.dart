import 'package:flutter/material.dart';
import 'package:movieowski/src/models/popular_movie_model.dart';
import 'package:movieowski/src/resources/api/tmdp_api_provider.dart';

class MovieCard extends StatelessWidget {
  final PopularMovie _movie;

  MovieCard(this._movie);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(12.0),
            child: Image.network(
                TmdbApiProvider.BASE_IMAGE_URL + _movie.poster_path),
          ),
          Container(
            margin: EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
            child: Center(
              child: Text(_movie.title),
            ),
          )
        ],
      ),
    );
  }
}
