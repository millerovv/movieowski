import 'package:bloc/bloc.dart';
import 'package:movieowski/src/blocs/person_details_page/bloc_person_details_page_event.dart';
import 'package:movieowski/src/blocs/person_details_page/bloc_person_details_page_state.dart';
import 'package:movieowski/src/model/api/response/person_details_response.dart';
import 'package:movieowski/src/resources/repository/movies_repository.dart';
import 'package:movieowski/src/resources/api/base_api_provider.dart';
import 'package:movieowski/src/utils/logger.dart';

class PersonDetailsPageBloc extends Bloc<PersonDetailsPageEvent, PersonDetailsPageState> {
	final MoviesRepository _moviesRepository;
	final int _personId;

	MoviesRepository get moviesRepository => _moviesRepository;

	PersonDetailsPageBloc(this._moviesRepository, this._personId)
			: assert(_moviesRepository != null),
				assert(_personId != null);

	@override
  PersonDetailsPageState get initialState => PersonDetailsIsEmpty();

	@override
	Stream<PersonDetailsPageState> mapEventToState(
			PersonDetailsPageState currentState, PersonDetailsPageEvent event) async* {
		if (event is FetchPersonDetails) {
			yield PersonDetailsIsLoading();
			try {
				PersonDetailsResponseRoot details = await _moviesRepository
						.fetchPersonDetails(personId: _personId, withMovieCredits: true);
				yield PersonDetailsIsLoaded(details);
			} on ApiRequestException catch (e, stacktrace) {
				Log.e(e, stacktrace);
				if (e is ApiRequestFailedException) {
					Log.e(e, e.apiResponse);
				}
				yield PersonDetailsError(e.message);
			}
		}
	}
}
