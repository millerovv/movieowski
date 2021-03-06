import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieowski/src/blocs/home_page/actors/popular_actors_section_bloc_export.dart';
import 'package:movieowski/src/model/api/response/popular_people_response.dart';
import 'package:movieowski/src/ui/widget/person_circle_card.dart';
import 'package:movieowski/src/utils/navigator.dart';

class PopularActorsSection extends StatefulWidget {
  @override
  _PopularActorsSectionState createState() => _PopularActorsSectionState();
}

class _PopularActorsSectionState extends State<PopularActorsSection> {
  PopularActorsSectionBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<PopularActorsSectionBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 16.0),
        child: Text('Actors', style: Theme.of(context).textTheme.headline),
      ),
      BlocBuilder<PopularActorsSectionEvent, PopularActorsSectionState>(
        bloc: _bloc,
        builder: (BuildContext context, PopularActorsSectionState state) {
          if (state is PopularActorsError) {
            return Center(
              child: Text(
                state.errorMessage,
                style: Theme.of(context).textTheme.headline,
              ),
            );
          } else if (state is PopularActorsIsLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List<Widget>.generate(state.actors.length, (index) {
                    Person person = state.actors[index];
                    String posterHeroTag = 'poster${this.hashCode}${person.id}';
                    return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                        child: GestureDetector(
                          onTap: () => goToPersonDetails(context, _bloc.moviesRepository, person.id, person.name,
                              person.profilePath, posterHeroTag),
                          child: (person.profilePath != null && person.profilePath != '')
                              ? PersonCircleCard(
                                  asStubCard: false,
                                  withHero: true,
                                  posterHeroTag: posterHeroTag,
                                  posterPath: person.profilePath,
                                  actorName: person.name)
                              : SizedBox(),
                        ));
                  }),
                ),
              ),
            );
          } else {
            return SizedBox();
          }
        },
      )
    ]);
  }
}
