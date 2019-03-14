import 'package:equatable/equatable.dart';

abstract class HomePageEvent extends Equatable {
  HomePageEvent([List props = const []]) : super(props);
}

class StartLoadingHomePage extends HomePageEvent {}

class NowPlayingMoviesLoaded extends HomePageEvent {}

class TrendingMoviesLoaded extends HomePageEvent {}

class PopularActorsLoaded extends HomePageEvent {}

class UpcomingMoviesLoaded extends HomePageEvent {}

class GenresLoaded extends HomePageEvent {}

// -- error events section

class SectionLoadingFailed extends HomePageEvent {
  final String errorMessage;

  SectionLoadingFailed(this.errorMessage) : super([errorMessage]);
}

class NowPlayingMoviesLoadingFailed extends SectionLoadingFailed {
  NowPlayingMoviesLoadingFailed(String errorMessage) : super(errorMessage);
}

class TrendingMoviesLoadingFailed extends SectionLoadingFailed {
  TrendingMoviesLoadingFailed(String errorMessage) : super(errorMessage);
}

class PopularActorsLoadingFailed extends SectionLoadingFailed {
  PopularActorsLoadingFailed(String errorMessage) : super(errorMessage);
}

class UpcomingMoviesFailed extends SectionLoadingFailed {
  UpcomingMoviesFailed(String errorMessage) : super(errorMessage);
}

class GenresLoadingFailed extends SectionLoadingFailed {
  GenresLoadingFailed(String errorMessage) : super(errorMessage);
}

// -- error events section end