import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieowski/src/blocs/home_page/movies/movies_section_bloc_export.dart';
import 'package:movieowski/src/ui/see_all/see_all_movies_page.dart';
import 'package:movieowski/src/ui/widget/movie_card.dart';
import 'package:movieowski/src/utils/navigator.dart';

class MoviesSection extends StatefulWidget {
  final sectionType;

  MoviesSection(this.sectionType);

  @override
  _MoviesSectionState createState() => _MoviesSectionState();
}

class _MoviesSectionState extends State<MoviesSection> {
  MoviesSectionBloc _bloc;

  @override
  void initState() {
    super.initState();
    switch (widget.sectionType) {
      case MovieSectionType.IN_THEATRES:
        _bloc = BlocProvider.of<NowPlayingMoviesSectionBloc>(context);
        break;
      case MovieSectionType.TRENDING:
        _bloc = BlocProvider.of<TrendingMoviesSectionBloc>(context);
        break;
      case MovieSectionType.UPCOMING:
        _bloc = BlocProvider.of<UpcomingMoviesSectionBloc>(context);
        break;
    }
  }

  SeeAllMoviesType _chooseSeeAllMoviesTypePage() {
    switch (widget.sectionType) {
      case MovieSectionType.IN_THEATRES:
        return SeeAllMoviesType.IN_THEATRES;
        break;
      case MovieSectionType.UPCOMING:
        return SeeAllMoviesType.UPCOMING;
        break;
      default:
        return null;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesSectionEvent, MoviesSectionState>(
      bloc: _bloc,
      builder: (BuildContext context, MoviesSectionState state) {
        if (state is MoviesError) {
          return Center(
            child: Text(
              state.errorMessage,
              style: Theme.of(context).textTheme.headline,
            ),
          );
        } else if (state is MoviesIsLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    Text(_bloc.sectionHeader, style: Theme.of(context).textTheme.headline),
                    _bloc.withSeeAllOption
                        ? GestureDetector(
                            onTap: () => goToSeeAllMovies(context, _chooseSeeAllMoviesTypePage(),
                                preloadedFirstPage: state.movies, maxPages: state.maxPages),
                            child: Text('See all',
                                style: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .copyWith(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold)))
                        : Container(),
                  ],
                ),
              ),
              Container(
                height: 224.3,
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    String cardHeroTag = 'card${this.hashCode}$index${state.movies[index].id}';
                    String ratingHeroTag = (widget.sectionType != MovieSectionType.UPCOMING)
                        ? 'rating${this.hashCode}$index${state.movies[index].id}'
                        : null;
                    return Padding(
                        padding: EdgeInsets.only(
                          left: (index == 0) ? 16.0 : 0.0,
                          right: 16.0,
                          top: 12.0,
                          bottom: 12.0,
                        ),
                        child: GestureDetector(
                          onTap: () => goToMovieDetails(
                              context, _bloc.moviesRepository, state.movies[index], cardHeroTag, ratingHeroTag),
                          child: (state.movies[index].posterPath != null && state.movies[index].posterPath != '')
                              ? MovieCard(
                                  withRating: widget.sectionType != MovieSectionType.UPCOMING,
                                  withHero: true,
                                  imageHeroTag: cardHeroTag,
                                  ratingHeroTag: ratingHeroTag,
                                  posterPath: state.movies[index].posterPath,
                                  rating: state.movies[index].voteAverage,
                                )
                              : SizedBox(),
                        ));
                  },
                  itemCount: state.movies.length,
                ),
              ),
            ],
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}

enum MovieSectionType { IN_THEATRES, TRENDING, UPCOMING }
