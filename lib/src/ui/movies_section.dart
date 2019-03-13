import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieowski/src/blocs/home_page/home_page_bloc.dart';
import 'package:movieowski/src/blocs/home_page/home_page_event.dart';
import 'package:movieowski/src/blocs/home_page/movies/bloc_movies_section.dart';
import 'package:movieowski/src/blocs/home_page/movies/bloc_now_playing_movies_section.dart';
import 'package:movieowski/src/blocs/home_page/movies/bloc_movies_section_event.dart';
import 'package:movieowski/src/blocs/home_page/movies/bloc_movies_section_state.dart';
import 'package:movieowski/src/blocs/home_page/movies/bloc_trending_movies_section.dart';
import 'package:movieowski/src/blocs/home_page/movies/bloc_upcoming_movies_section.dart';
import 'package:movieowski/src/ui/movie_card.dart';

class MoviesSection extends StatefulWidget {
  final sectionType;

  MoviesSection(this.sectionType);

  @override
  _MoviesSectionState createState() => _MoviesSectionState();
}

class _MoviesSectionState extends State<MoviesSection> {
  MoviesSectionBloc _bloc;
  HomePageBloc _supervisorBloc;

  StreamSubscription<MoviesSectionState> _sectionBlocSubscription;

  @override
  void initState() {
    super.initState();
    _supervisorBloc = BlocProvider.of<HomePageBloc>(context);
    switch (widget.sectionType) {
      case MovieSectionType.IN_THEATRES:
        {
          _bloc = BlocProvider.of<NowPlayingMoviesSectionBloc>(context);
          break;
        }
      case MovieSectionType.TRENDING:
        {
          _bloc = BlocProvider.of<TrendingMoviesSectionBloc>(context);
          break;
        }
      case MovieSectionType.UPCOMING:
        {
          _bloc = BlocProvider.of<UpcomingMoviesSectionBloc>(context);
          break;
        }
    }
    _subscribeToSectionBloc();
  }

  @override
  void dispose() {
    _unsubscribeFromSectionBloc();
    _supervisorBloc?.dispose();
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        BlocBuilder<MoviesSectionEvent, MoviesSectionState>(
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
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                height: 224.3,
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: (state.movies[index].posterPath != null)
                              ? HomeMovieCard(
                                  forAndroid: Theme.of(context).platform == TargetPlatform.android,
                                  withRating: widget.sectionType != MovieSectionType.UPCOMING,
                                  posterPath: state.movies[index].posterPath,
                                  rating: state.movies[index].voteAverage,
                                )
                              : SizedBox()
                    );
                  },
                  //TODO: Заменить тройку на высчитываемое значение относительно ширины экрана
                  itemCount: (state is MoviesIsLoaded) ? state.movies.length : 5,
                ),
              );
            } else {
              return SizedBox();
            }
          },
        )
      ],
    );
  }

  void _subscribeToSectionBloc() {
    if (_bloc.state != null) {
      _sectionBlocSubscription = _bloc.state.skip(1).listen((MoviesSectionState state) {
        if (state is MoviesIsLoaded) {
          _supervisorBloc.dispatch(_getHomeEventBaseOnSectionType(sectionType: widget.sectionType, errorEvent: false));
        } else if (state is MoviesError) {
          _supervisorBloc.dispatch(_getHomeEventBaseOnSectionType(
              sectionType: widget.sectionType, errorEvent: true, errorMessage: state.errorMessage));
        }
      });
    }
  }

  void _unsubscribeFromSectionBloc() {
    if (_sectionBlocSubscription != null) {
      _sectionBlocSubscription.cancel();
      _sectionBlocSubscription = null;
    }
  }
}

enum MovieSectionType { IN_THEATRES, TRENDING, UPCOMING }

/// Returns suitable HomePageEvent based on SectionType; errorEvent = true – function returns [SectionLoadingFailed],
/// otherwise it returns "section movies loaded" events
HomePageEvent _getHomeEventBaseOnSectionType(
    {@required MovieSectionType sectionType, @required bool errorEvent, String errorMessage}) {
  if (errorEvent) {
    switch (sectionType) {
      case MovieSectionType.IN_THEATRES:
        return NowPlayingMoviesLoadingFailed(errorMessage);
        break;
      case MovieSectionType.TRENDING:
        return TrendingMoviesLoadingFailed(errorMessage);
        break;
      case MovieSectionType.UPCOMING:
        return UpcomingMoviesFailed(errorMessage);
        break;
      default:
        return SectionLoadingFailed(errorMessage);
        break;
    }
  } else {
    switch (sectionType) {
      case MovieSectionType.IN_THEATRES:
        return NowPlayingMoviesLoaded();
        break;
      case MovieSectionType.TRENDING:
        return TrendingMoviesLoaded();
        break;
      case MovieSectionType.UPCOMING:
        return UpcomingMoviesLoaded();
        break;
      default:
        throw ArgumentError('Unknown SectionType argument has been passed to this function');
        break;
    }
  }
}
