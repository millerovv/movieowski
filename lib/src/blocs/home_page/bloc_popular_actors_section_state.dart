import 'package:equatable/equatable.dart';
import 'package:movieowski/src/blocs/base/bloc_event_state.dart';
import 'package:movieowski/src/model/api/response/person_details_response.dart';

abstract class PopularActorsSectionState extends Equatable implements BlocState {
	PopularActorsSectionState([List props = const []]);
}

class PopularActorsIsEmpty extends PopularActorsSectionState {}

class PopularActorsIsLoading extends PopularActorsSectionState {}

class PopularActorsIsLoaded extends PopularActorsSectionState {
	final List<PersonDetailsResponseRoot> actors;

	PopularActorsIsLoaded(this.actors) :
				assert(actors != null),
				super(actors);
}

class PopularActorsError extends PopularActorsSectionState {
	final String errorMessage;

	PopularActorsError(this.errorMessage) : super([errorMessage]);
}