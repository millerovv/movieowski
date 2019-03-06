import 'package:flutter/material.dart';
import 'package:movieowski/src/blocs/base/bloc_event_state_builder.dart';
import 'package:movieowski/src/blocs/base/bloc_provider.dart';
import 'package:movieowski/src/blocs/popular_movies/bloc_now_playing_movies_section.dart';
import 'package:movieowski/src/blocs/popular_movies/bloc_now_playing_movies_section_event.dart';
import 'package:movieowski/src/blocs/popular_movies/bloc_now_playing_movies_section_state.dart';
import 'package:movieowski/src/ui/movie_card.dart';

class NowPlayingMoviesSection extends StatefulWidget {
  @override
  _NowPlayingMoviesSectionState createState() => _NowPlayingMoviesSectionState();
}

class _NowPlayingMoviesSectionState extends State<NowPlayingMoviesSection> {
	NowPlayingMoviesSectionBloc _bloc;

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
						  Text('In theaters', style: Theme.of(context).textTheme.headline),
						  Text('See all',
								  style: Theme.of(context)
										  .textTheme
										  .body1
										  .copyWith(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold)),
					  ],
				  ),
			  ),
			  BlocEventStateBuilder<NowPlayingMoviesSectionEvent, NowPlayingMoviesSectionState>(
				  bloc: _bloc,
				  builder: (BuildContext context, NowPlayingMoviesSectionState state) {
				  	print('state ${state.runtimeType.toString()}');
				  	if (state is NowPlayingMoviesIsEmpty) {
				  		_bloc.emitEvent(FetchNowPlayingMovies(page: 1));
				  		return Container(child: CircularProgressIndicator(),);
					  } else if (state is NowPlayingMoviesIsLoaded) {
				  		return Container(
							  height: 220.3,
							  width: double.infinity,
				  		  child: ListView.builder(
							    scrollDirection: Axis.horizontal,
								  itemBuilder: (BuildContext context, int index) {
								  	return Padding(
										  padding: EdgeInsets.only(left: index == 0 ? 16.0 : 8.0),
										  child: HomeMovieCard(
												  state.nowPlayingMovies[index].posterPath,
												  state.nowPlayingMovies[index].voteAverage,
										      Theme.of(context).platform == TargetPlatform.android),
									  );
								  },
									itemCount: state.nowPlayingMovies.length,
						  ),
				  		);
					  } else {
						  return Container(child: CircularProgressIndicator(),);
					  }
				  },
			  )
		  ],
	  );
  }

	@override
	void dispose() {
		_bloc?.dispose();
		super.dispose();
	}

}
