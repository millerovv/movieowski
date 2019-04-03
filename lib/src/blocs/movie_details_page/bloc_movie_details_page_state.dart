import 'package:equatable/equatable.dart';

abstract class MovieDetailsPageState extends Equatable {
	MovieDetailsPageState([List props = const []]);
}

class MovieDetailsIsEmpty extends MovieDetailsPageState {}

class MovieDetailsIsLoading extends MovieDetailsPageState {}

class MovieDetailsIsLoaded extends MovieDetailsPageState {
	final List details;

	MovieDetailsIsLoaded(this.details) :
			assert(details != null),
			super(details);
}

class MovieDetailsError extends MovieDetailsPageState {
	final String errorMessage;

	MovieDetailsError(this.errorMessage) : super([errorMessage]);
}