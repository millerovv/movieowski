import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieowski/src/blocs/query_search_results/query_search_results_export.dart';
import 'package:movieowski/src/model/api/response/base_movies_response.dart';
import 'package:movieowski/src/model/api/response/popular_people_response.dart';
import 'package:movieowski/src/model/api/response/search_movies_response.dart';
import 'package:movieowski/src/model/api/response/search_people_response.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';
import 'package:movieowski/src/ui/widget/person_list_card.dart';
import 'package:movieowski/src/ui/widget/movie_list_card.dart';
import 'package:movieowski/src/utils/navigator.dart';

class QuerySearchResults extends StatefulWidget {
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

  @override
  _QuerySearchResultsState createState() => _QuerySearchResultsState();
}

class _QuerySearchResultsState extends State<QuerySearchResults> {
  QuerySearchResultsBloc _bloc;

  @override
  initState() {
    _bloc = BlocProvider.of<QuerySearchResultsBloc>(context);
    _bloc.dispatch(FetchMovieGenres());
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  Widget _createFoundMoviesPage(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: widget.movies.length,
        itemBuilder: (context, index) {
          Movie movie = widget.movies[index];
          String imageHeroTag = 'searched_movie_card$index/${movie.id}';
          String ratingHeroTag = 'searched_movie_rating$index/${movie.id}';
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: GestureDetector(
              onTap: () => goToMovieDetails(context, widget.moviesRepository, movie, imageHeroTag, ratingHeroTag),
              child: BlocBuilder(
                  bloc: _bloc,
                  builder: (context, state) {
                    String genres;
                    if (state is MovieGenresIsLoaded) {
                      debugPrint('for movie:${movie.title} genreIds = ${movie.genreIds}');
                      debugPrint('all genres = ${state.genres.toString()}');
                      genres = state.genres
                          .where((genre) => movie.genreIds.contains(genre.id))
                          .map((genre) => genre.name)
                          .toList()
                          .toString()
                          .replaceAll('[', '')
                          .replaceAll(']', '');
                    } else {
                      genres = '';
                    }
                    return MovieListCard(
                      withHero: true,
                      imageHeroTag: imageHeroTag,
                      ratingHeroTag: ratingHeroTag,
                      posterPath: movie.posterPath,
                      rating: movie.voteAverage,
                      title: movie.title,
                      releaseYear: movie.releaseDate?.split('-')[0],
                      genres: genres,
                    );
                  }),
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
        itemCount: widget.movies.length,
        itemBuilder: (context, index) {
          Person person = widget.people[index];
          String imageHeroTag = 'searched_movie_card$index/${person.id}';
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: GestureDetector(
              onTap: () => goToPersonDetails(context, widget.moviesRepository, person, imageHeroTag),
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
                  child: (widget.loaded && widget.movies != null)
                      ? _createFoundMoviesPage(context)
                      : CircularProgressIndicator(),
                ),
                Center(
                  child: (widget.loaded && widget.people != null)
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
