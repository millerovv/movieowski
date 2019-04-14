import 'package:equatable/equatable.dart';
import 'package:movieowski/src/model/api/response/search_movies_response.dart';
import 'package:movieowski/src/model/api/response/search_people_response.dart';

abstract class HomePageState extends Equatable {
  HomePageState([List props = const []]);
}

class HomePageNotLoaded extends HomePageState {}

class HomePageIsLoading extends HomePageState {}

class HomePageIsLoaded extends HomePageState {}

class HomePageLoadingFailed extends HomePageState {
  final String errorMessage;

  HomePageLoadingFailed(this.errorMessage) : super([errorMessage]);
}

class SearchByQueryIsLoading extends HomePageState {}

class SearchByQueryIsLoaded extends HomePageState {
  final SearchMoviesResponseRoot movies;
  final SearchPeopleResponseRoot people;

  SearchByQueryIsLoaded(this.movies, this.people);
}

class SearchByQueryLoadingFailed extends HomePageState {
  final String errorMessage;

  SearchByQueryLoadingFailed(this.errorMessage) : super([errorMessage]);
}
