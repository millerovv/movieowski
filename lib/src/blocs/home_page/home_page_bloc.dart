import 'package:bloc/bloc.dart';
import 'package:movieowski/src/blocs/home_page/home_page_event.dart';
import 'package:movieowski/src/blocs/home_page/home_page_state.dart';
import 'package:movieowski/src/utils/logger.dart';

/// This BLOC controls section content loading statuses.
/// Emits [HomePageIsLoaded] state when all sections have been loaded
class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {

  final Map<HomeSection, bool> sectionsLoadedStatuses = {
    HomeSection.NOW_PLAYING: false,
    HomeSection.TRENDING: false,
    HomeSection.ACTORS: false,
    HomeSection.UPCOMING: false,
    HomeSection.CATEGORIES: false
  };

  @override
  HomePageState get initialState => HomePageNotLoaded();

  @override
  Stream<HomePageState> mapEventToState(HomePageState currentState,
      HomePageEvent event) async* {
    if (event is SectionLoadingFailed) {
      yield HomePageLoadingFailed(event.errorMessage);
    } else if (event is StartLoadingHomePage) {
      yield HomePageIsLoading();
    } else {
      if (event is NowPlayingMoviesLoaded) {
        sectionsLoadedStatuses[HomeSection.NOW_PLAYING] = true;
      } else if (event is TrendingMoviesLoaded) {
        sectionsLoadedStatuses[HomeSection.TRENDING] = true;
      } else if (event is PopularActorsLoaded) {
        sectionsLoadedStatuses[HomeSection.ACTORS] = true;
      } else if (event is UpcomingMoviesLoaded) {
        sectionsLoadedStatuses[HomeSection.UPCOMING] = true;
      } else if (event is GenresLoaded) {
        sectionsLoadedStatuses[HomeSection.CATEGORIES] = true;
      }
      if (_allSectionsLoaded()) {
        yield HomePageIsLoaded();
      }
    }
  }
  
  bool _allSectionsLoaded() {
    int loadedCnt = 0;
    sectionsLoadedStatuses.values.forEach((status) => status ? loadedCnt++ : null);
//    return loadedCnt == HomeSection.values.length;
    Log.d('loadedCnt = $loadedCnt', 'HomePageBloc');
    return loadedCnt == 4;
  }
}

enum HomeSection {
  NOW_PLAYING, TRENDING, ACTORS, UPCOMING, CATEGORIES
}