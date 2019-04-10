import 'package:flutter/material.dart';
import 'package:movieowski/src/model/api/response/base_movies_response.dart';
import 'package:movieowski/src/model/api/response/popular_people_response.dart';
import 'package:movieowski/src/model/api/response/search_movies_response.dart';
import 'package:movieowski/src/model/api/response/search_people_response.dart';
import 'package:movieowski/src/ui/widget/movie_list_card.dart';

class QuerySearchResults extends StatelessWidget {
  final bool loaded;
  final SearchMoviesResponseRoot moviesRoot;
  final SearchPeopleResponseRoot peopleRoot;
  final List<Movie> movies;
  final List<Person> people;

  QuerySearchResults({Key key, this.loaded, this.moviesRoot, this.peopleRoot}) :
      movies = moviesRoot?.movies,
      people = peopleRoot?.people,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          TabBar(
            tabs: <Widget>[
              Tab(text: 'MOVIES'),
              Tab(text: 'PEOPLE'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: <Widget>[
                Center(
                  child: loaded && movies != null && people != null ? MovieListCard(
                    posterPath: movies[0].posterPath,
                    rating: movies[0].voteAverage,
                  ) : CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
