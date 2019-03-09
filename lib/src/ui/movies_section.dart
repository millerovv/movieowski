import 'package:flutter/material.dart';
import 'package:movieowski/src/blocs/base/bloc_event_state_builder.dart';
import 'package:movieowski/src/blocs/base/bloc_provider.dart';
import 'package:movieowski/src/blocs/home_page/movies/bloc_movies_section.dart';
import 'package:movieowski/src/blocs/home_page/movies/bloc_now_playing_movies_section.dart';
import 'package:movieowski/src/blocs/home_page/movies/bloc_movies_section_event.dart';
import 'package:movieowski/src/blocs/home_page/movies/bloc_movies_section_state.dart';
import 'package:movieowski/src/blocs/home_page/movies/bloc_trending_movies_section.dart';
import 'package:movieowski/src/blocs/home_page/movies/bloc_upcoming_movies_section.dart';
import 'package:movieowski/src/ui/movie_card.dart';
import 'package:movieowski/src/utils/consts.dart';
import 'package:shimmer/shimmer.dart';

class MoviesSection extends StatefulWidget {
  final sectionType;

  MoviesSection(this.sectionType);

  @override
  _MoviesSectionState createState() => _MoviesSectionState();
}

class _MoviesSectionState extends State<MoviesSection> {
  MoviesSectionBloc _bloc;

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.sectionType) {
      case SectionType.IN_THEATRES:
        {
          _bloc = BlocProvider.of<NowPlayingMoviesSectionBloc>(context);
          break;
        }
      case SectionType.TRENDING:
        {
          _bloc = BlocProvider.of<TrendingMoviesSectionBloc>(context);
          break;
        }
      case SectionType.UPCOMING:
        {
          _bloc = BlocProvider.of<UpcomingMoviesSectionBloc>(context);
          break;
        }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text(_bloc.sectionHeader, style: Theme.of(context).textTheme.headline),
              _bloc.withSeeAllOption
                  ? Text('See all',
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold))
                  : Container(),
            ],
          ),
        ),
        BlocEventStateBuilder<MoviesSectionEvent, MoviesSectionState>(
          bloc: _bloc,
          builder: (BuildContext context, MoviesSectionState state) {
            if (state is MoviesIsEmpty) {
              _bloc.emitEvent(FetchMovies(page: 1));
              return SizedBox();
            } else if (state is MoviesError) {
              return Center(
                child: Text(
                  state.errorMessage,
                  style: Theme.of(context).textTheme.headline,
                ),
              );
            } else {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                height: 224.3,
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: (state is MoviesIsLoaded)
                          ? (state.movies[index].posterPath != null) ? HomeMovieCard(
                              forAndroid: Theme.of(context).platform == TargetPlatform.android,
                              withRating: widget.sectionType != SectionType.UPCOMING,
                              posterPath: state.movies[index].posterPath,
                              rating: state.movies[index].voteAverage,
                            ) : SizedBox()
                          : Shimmer.fromColors(
                              baseColor: AppColors.lighterPrimary,
                              highlightColor: Colors.grey,
                              child: HomeMovieCard(
                                forAndroid: false,
                                withRating: widget.sectionType != SectionType.UPCOMING,
                              )),
                    );
                  },
                  //TODO: Заменить тройку на высчитываемое значение относительно ширины экрана
                  itemCount: (state is MoviesIsLoaded) ? state.movies.length : 5,
                ),
              );
            }
          },
        )
      ],
    );
  }
}

enum SectionType { IN_THEATRES, TRENDING, UPCOMING }
