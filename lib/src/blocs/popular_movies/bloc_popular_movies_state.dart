import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:movieowski/src/blocs/base/bloc_event_state.dart';
import 'package:movieowski/src/models/popular_movie_model.dart';

class PopularMoviesState extends Equatable implements BlocState {
  final bool isLoaded;
  final bool isLoading;
  final bool hasFailed;
  final PopularMoviesModel popularMovies;

  PopularMoviesState(
      {@required this.isLoaded,
      this.isLoading: false,
      this.hasFailed: false,
      @required this.popularMovies});

  factory PopularMoviesState.notInitialized() {
    return PopularMoviesState(isLoaded: false, popularMovies: PopularMoviesModel.empty());
  }

  factory PopularMoviesState.loading() {
    return PopularMoviesState(
      isLoaded: false,
      isLoading: true,
      popularMovies: PopularMoviesModel.empty(),
    );
  }

  factory PopularMoviesState.loaded(PopularMoviesModel popularMovies) {
    return PopularMoviesState(
      isLoaded: true,
      isLoading: false,
      popularMovies: popularMovies,
    );
  }

  factory PopularMoviesState.error() {
    return PopularMoviesState(isLoaded: false, popularMovies: PopularMoviesModel.empty());
  }
}
