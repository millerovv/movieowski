import 'package:movieowski/src/utils/consts.dart';
import 'package:equatable/equatable.dart';

abstract class PopularMoviesEvent extends Equatable {
  PopularMoviesEvent([List props = const []]) : super(props);
}

class FetchPopularMovies extends PopularMoviesEvent {
  final int page;
  final String language;
  final String region;

  FetchPopularMovies({this.page: 1, this.language: Languages.ENGLISH, this.region: Regions.RUSSIA});
}
