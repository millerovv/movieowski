import 'package:flutter/material.dart';
import 'package:movieowski/src/model/api/response/base_movies_response.dart';
import 'package:movieowski/src/model/api/response/popular_people_response.dart';
import 'package:movieowski/src/model/api/response/search_movies_response.dart';
import 'package:movieowski/src/model/api/response/search_people_response.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';
import 'package:movieowski/src/ui/widget/actor_list_card.dart';
import 'package:movieowski/src/ui/widget/movie_list_card.dart';
import 'package:movieowski/src/utils/navigator.dart';

// TODO: delete genres hardcode
class QuerySearchResults extends StatelessWidget {
  final bool loaded;
  final SearchMoviesResponseRoot moviesRoot;
  final SearchPeopleResponseRoot peopleRoot;
  final List<Movie> movies;
  final List<Person> people;
  final MoviesRepository moviesRepository;

  QuerySearchResults({Key key, this.loaded, this.moviesRoot, this.peopleRoot, this.moviesRepository})
      : movies = moviesRoot?.movies,
        people = peopleRoot?.people,
        super(key: key);  

  Widget _createFoundMoviesPage(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          Movie movie = movies[index];
          String imageHeroTag = 'searched_movie_card$index/${movie.id}';
          String ratingHeroTag = 'searched_movie_rating$index/${movie.id}';
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: GestureDetector(
              onTap: () => goToMovieDetails(context, moviesRepository, movie, imageHeroTag, ratingHeroTag),
              child: MovieListCard(
                withHero: true,
                imageHeroTag: imageHeroTag,
                ratingHeroTag: ratingHeroTag,
                posterPath: movie.posterPath,
                rating: movie.voteAverage,
                title: movie.title,
                releaseYear: movie.releaseDate.split('-')[0],
                genres: 'Animation, Family, Adventure',
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _createFoundPeoplePage(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4.0),
      child: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          Person person = people[index];
          String imageHeroTag = 'searched_movie_card$index/${person.id}';
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: GestureDetector(
              onTap: () => goToPersonDetails(context, moviesRepository, person, imageHeroTag),
              child: ActorListCard(
                photoPath: person.profilePath,
                name: person.name,
                withHero: true,
                imageHeroTag: imageHeroTag,
              ),
            ),
          );
        },
      ),
    );
  }

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
                  child: (loaded && movies != null)
                      ? _createFoundMoviesPage(context)
                      : CircularProgressIndicator(),
                ),
                Center(
                  child: (loaded && people != null)
                      ? _createFoundPeoplePage(context)
                      : CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
