import 'package:equatable/equatable.dart';
import 'package:movieowski/src/model/api/response/person_details_response.dart';

abstract class PersonDetailsPageState extends Equatable {
	PersonDetailsPageState([List props = const []]);
}

class PersonDetailsIsEmpty extends PersonDetailsPageState {}

class PersonDetailsIsLoading extends PersonDetailsPageState {}

class PersonDetailsIsLoaded extends PersonDetailsPageState {
	final PersonDetailsResponseRoot details;

	PersonDetailsIsLoaded(this.details) :
				assert(details != null),
				super([details]);
}

class PersonDetailsError extends PersonDetailsPageState {
	final String errorMessage;

	PersonDetailsError(this.errorMessage) : super([errorMessage]);
}