import 'package:equatable/equatable.dart';
import 'package:movieowski/src/model/api/response/movie_details_with_credits_response.dart';

abstract class MovieDetailsPageState extends Equatable {
	MovieDetailsPageState([List props = const []]);
}

class MovieDetailsIsEmpty extends MovieDetailsPageState {}

class MovieDetailsIsLoading extends MovieDetailsPageState {}

class MovieDetailsIsLoaded extends MovieDetailsPageState {
	final MovieDetailsWithCreditsResponseRoot details;

	MovieDetailsIsLoaded(this.details) :
			assert(details != null),
			super([details]);
}

class MovieDetailsError extends MovieDetailsPageState {
	final String errorMessage;

	MovieDetailsError(this.errorMessage) : super([errorMessage]);
}