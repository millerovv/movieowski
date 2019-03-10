import 'package:equatable/equatable.dart';

abstract class MovieGenresSectionEvent extends Equatable {
	MovieGenresSectionEvent([List props = const []]) : super(props);
}

class FetchGenres extends MovieGenresSectionEvent {}
