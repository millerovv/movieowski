import 'package:equatable/equatable.dart';

abstract class MovieDetailsPageEvent extends Equatable {
	MovieDetailsPageEvent([List props = const []]);
}

class FetchMovieDetails extends MovieDetailsPageEvent {}