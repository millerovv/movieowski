import 'package:equatable/equatable.dart';

abstract class HomePageEvent extends Equatable {
  HomePageEvent([List props = const []]) : super(props);
}

class StartLoadingHomePage extends HomePageEvent {}

class NotifyNowPlayingMoviesLoaded extends HomePageEvent {}

class NotifyTrendingMoviesLoaded extends HomePageEvent {}

class NotifyPopularActorsLoaded extends HomePageEvent {}

class NotifyUpcomingMoviesLoaded extends HomePageEvent {}

class NotifyGenresLoaded extends HomePageEvent {}

class FetchSearchByQuery extends HomePageEvent {
  final String query;

  FetchSearchByQuery(this.query);
}

class CancelSearch extends HomePageEvent {}

// -- error events section

class NotifySectionLoadingFailed extends HomePageEvent {
  final String errorMessage;

  NotifySectionLoadingFailed(this.errorMessage) : super([errorMessage]);
}

class NotifyNowPlayingMoviesLoadingFailed extends NotifySectionLoadingFailed {
  NotifyNowPlayingMoviesLoadingFailed(String errorMessage) : super(errorMessage);
}

class NotifyTrendingMoviesLoadingFailed extends NotifySectionLoadingFailed {
  NotifyTrendingMoviesLoadingFailed(String errorMessage) : super(errorMessage);
}

class NotifyPopularActorsLoadingFailed extends NotifySectionLoadingFailed {
  NotifyPopularActorsLoadingFailed(String errorMessage) : super(errorMessage);
}

class NotifyUpcomingMoviesFailed extends NotifySectionLoadingFailed {
  NotifyUpcomingMoviesFailed(String errorMessage) : super(errorMessage);
}

class NotifyGenresLoadingFailed extends NotifySectionLoadingFailed {
  NotifyGenresLoadingFailed(String errorMessage) : super(errorMessage);
}

// -- error events section end