import 'package:flutter/material.dart';
import 'package:movieowski/src/blocs/base/bloc_event_state_builder.dart';
import 'package:movieowski/src/blocs/base/bloc_provider.dart';
import 'package:movieowski/src/blocs/home_page/bloc_now_playing_movies_section.dart';
import 'package:movieowski/src/blocs/home_page/bloc_now_playing_movies_section_event.dart';
import 'package:movieowski/src/blocs/home_page/bloc_now_playing_movies_section_state.dart';
import 'package:movieowski/src/ui/movie_card.dart';

class MoviesSection extends StatefulWidget {
  @override
  _MoviesSectionState createState() => _MoviesSectionState();
}

class _MoviesSectionState extends State<MoviesSection> {
	NowPlayingMoviesSectionBloc _bloc;

	@override
	void dispose() {
		_bloc?.dispose();
		super.dispose();
	}

  @override
  Widget build(BuildContext context) {
  	_bloc = BlocProvider.of<NowPlayingMoviesSectionBloc>(context);
	  return Column(
		  crossAxisAlignment: CrossAxisAlignment.start,
		  children: <Widget>[
			  Padding(
				  padding: EdgeInsets.only(top: 12.0, left: 16.0, right: 16.0),
				  child: Row(
					  mainAxisAlignment: MainAxisAlignment.spaceBetween,
					  crossAxisAlignment: CrossAxisAlignment.baseline,
					  textBaseline: TextBaseline.alphabetic,
					  children: <Widget>[
						  Text(_bloc.sectionHeader, style: Theme.of(context).textTheme.headline),
						  _bloc.withSeeAllOption ? Text('See all',
								  style: Theme.of(context)
										  .textTheme
										  .body1
										  .copyWith(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold)) : Container(),
					  ],
				  ),
			  ),
			  BlocEventStateBuilder<MoviesSectionEvent, MoviesSectionState>(
				  bloc: _bloc,
				  builder: (BuildContext context, MoviesSectionState state) {
//				  	print('SECTION STATE ${state.runtimeType.toString()}');
				  	if (state is MoviesIsEmpty) {
				  		_bloc.emitEvent(FetchMovies(page: 1));
				  		return Container(child: CircularProgressIndicator(),);
					  } else if (state is MoviesIsLoaded) {
				  		return Container(
							  height: 220.3,
							  width: double.infinity,
				  		  child: ListView.builder(
							    scrollDirection: Axis.horizontal,
								  itemBuilder: (BuildContext context, int index) {
								  	return Padding(
										  padding: EdgeInsets.only(left: index == 0 ? 16.0 : 8.0),
										  child: HomeMovieCard(
												  state.movies[index].posterPath,
												  state.movies[index].voteAverage,
										      Theme.of(context).platform == TargetPlatform.android),
									  );
								  },
									itemCount: state.movies.length,
						  ),
				  		);
					  } else if (state is MoviesError){
						  return Center(child: Text(state.errorMessage, style: Theme.of(context).textTheme.headline,),);
					  } else {
				  	  return Container(child: CircularProgressIndicator(),);
            }
				  },
			  )
		  ],
	  );
  }

}
