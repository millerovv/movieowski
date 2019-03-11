import 'package:equatable/equatable.dart';

abstract class PopularActorsSectionEvent extends Equatable {
	PopularActorsSectionEvent([List props = const []]) : super(props);
}

class FetchPopularActors extends PopularActorsSectionEvent {}
