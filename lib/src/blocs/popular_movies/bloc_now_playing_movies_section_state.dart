import 'package:equatable/equatable.dart';
import 'package:movieowski/src/blocs/base/bloc_event_state.dart';
import 'package:movieowski/src/models/now_playing_movies_response.dart';

abstract class NowPlayingMoviesSectionState extends Equatable implements BlocState {
  NowPlayingMoviesSectionState([List props = const []]);
}

class NowPlayingMoviesIsEmpty extends NowPlayingMoviesSectionState {}

class NowPlayingMoviesIsLoading extends NowPlayingMoviesSectionState {}

class NowPlayingMoviesIsLoaded extends NowPlayingMoviesSectionState {
  final List<NowPlayingMovie> nowPlayingMovies;

  NowPlayingMoviesIsLoaded(this.nowPlayingMovies) :
        assert(nowPlayingMovies != null),
        super(nowPlayingMovies);
}

class NowPlayingMoviesError extends NowPlayingMoviesSectionState {}