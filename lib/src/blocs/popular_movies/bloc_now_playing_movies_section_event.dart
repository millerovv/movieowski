import 'package:movieowski/src/blocs/base/bloc_event_state.dart';
import 'package:movieowski/src/utils/consts.dart';
import 'package:equatable/equatable.dart';

abstract class NowPlayingMoviesSectionEvent extends Equatable implements BlocEvent {
  NowPlayingMoviesSectionEvent([List props = const []]) : super(props);
}

class FetchNowPlayingMovies extends NowPlayingMoviesSectionEvent {
  final int page;
  final String language;
  final String region;

  FetchNowPlayingMovies({this.page: 1, this.language: Languages.ENGLISH, this.region: Regions.RUSSIA});
}
