import 'package:equatable/equatable.dart';
import 'package:movieowski/src/model/api/response/popular_people_response.dart';

abstract class PopularActorsSectionState extends Equatable {
	PopularActorsSectionState([List props = const []]);
}

class PopularActorsIsEmpty extends PopularActorsSectionState {}

class PopularActorsIsLoading extends PopularActorsSectionState {}

class PopularActorsIsLoaded extends PopularActorsSectionState {
	final List<Person> actors;

	PopularActorsIsLoaded(this.actors) :
				assert(actors != null),
				super([actors]);
}

class PopularActorsError extends PopularActorsSectionState {
	final String errorMessage;

	PopularActorsError(this.errorMessage) : super([errorMessage]);
}