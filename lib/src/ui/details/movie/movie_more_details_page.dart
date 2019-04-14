import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieowski/src/blocs/movie_details_page/movie_details_page_bloc_export.dart';
import 'package:movieowski/src/model/api/response/movie_details_with_credits_response.dart';
import 'package:movieowski/src/ui/widget/actor_card.dart';
import 'package:movieowski/src/utils/consts.dart';
import 'package:movieowski/src/utils/ui_utils.dart';

class MovieMoreDetails extends StatefulWidget {
  @override
  _MovieMoreDetailsState createState() => _MovieMoreDetailsState();
}

//TODO: delete hardcoded genres and budget, format runtime correctly
class _MovieMoreDetailsState extends State<MovieMoreDetails> {
  MovieDetailsPageBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<MovieDetailsPageBloc>(context);
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: kToolbarHeight),
      color: AppColors.primaryColor,
      child: BlocBuilder(
        bloc: _bloc,
        builder: (BuildContext context, MovieDetailsPageState state) {
          if (state is MovieDetailsIsLoaded) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _createCastSection(state.details.credits.cast),
                  createBasicTitleSubtitleSection(context, 'Genres', 'Action, Science Fiction. Thriller, Adventure'),
                  createBasicTitleSubtitleSection(context, 'Storyline', state.details.overview),
                  createBasicTitleSubtitleSection(context, 'Country', state.details.productionCountries[0].name),
                  createBasicTitleSubtitleSection(context, 'Budget', state.details.budget.toString()),
                  createBasicTitleSubtitleSection(context, 'Runtime', state.details.runtime.toString() + ' min'),
                ],
              ),
            );
          } else if (state is MovieDetailsIsEmpty || state is MovieDetailsIsLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                child: Text(
                  'An error has occured while trying to download movie details. \n\n'
                      'Please check your internet connection and try again',
                  style: Theme.of(context).textTheme.headline.copyWith(color: AppColors.primaryWhite),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _createCastSection(List<Cast> cast) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 16.0, top: 16.0),
          child: Text(
            'Cast',
            style:
                Theme.of(context).textTheme.body1.copyWith(color: AppColors.primaryWhite, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List<Widget>.generate((cast.length <= 16) ? cast.length : 16, (index) {
                return Padding(
                    padding: ((cast[index].profilePath != null && cast[index].profilePath.isNotEmpty))
                        ? const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0) : const EdgeInsets.all(0),
                    child: GestureDetector(
//                      onTap: () => goToPersonDetails(context, _bloc.moviesRepository, case[index]),
                      child: ActorCircleImage(
                        width: 96.0,
                        asStubCard: false,
                        posterPath: cast[index].profilePath,
                        actorName: cast[index].name,
                        withSubTitle: true,
                        subTitle: cast[index].character,
                      ),
                    ));
              }),
            ),
          ),
        ),
      ],
    );
  }


}