import 'package:equatable/equatable.dart';

abstract class BaseMoviesResponse extends Equatable {}

abstract class BaseResponseMovie extends Equatable {
	double voteAverage;
	String posterPath;
}