import 'package:movieowski/src/utils/consts.dart';
import 'package:equatable/equatable.dart';

abstract class MoviesSectionEvent extends Equatable {
  MoviesSectionEvent([List props = const []]) : super(props);
}

class FetchMovies extends MoviesSectionEvent {
  final int page;
  final String language;
  final String region;

  FetchMovies({this.page: 1, this.language: Languages.ENGLISH, this.region: Regions.RUSSIA});
}
