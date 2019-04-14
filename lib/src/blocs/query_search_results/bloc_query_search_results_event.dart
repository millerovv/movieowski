import 'package:equatable/equatable.dart';

abstract class QuerySearchResultsEvent extends Equatable {
	QuerySearchResultsEvent([List props = const []]);
}

class FetchMovieGenres extends QuerySearchResultsEvent {}