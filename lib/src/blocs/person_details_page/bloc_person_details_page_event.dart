import 'package:equatable/equatable.dart';

abstract class PersonDetailsPageEvent extends Equatable {
	PersonDetailsPageEvent([List props = const []]);
}

class FetchPersonDetails extends PersonDetailsPageEvent {}