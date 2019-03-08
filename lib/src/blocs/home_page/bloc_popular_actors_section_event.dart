import 'package:equatable/equatable.dart';
import 'package:movieowski/src/blocs/base/bloc_event_state.dart';

abstract class PopularActorsSectionEvent extends Equatable implements BlocEvent {
	PopularActorsSectionEvent([List props = const []]) : super(props);
}

class FetchPopularActors extends PopularActorsSectionEvent {}
