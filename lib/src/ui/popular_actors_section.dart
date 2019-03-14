import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieowski/src/blocs/home_page/actors/popular_actors_section_bloc_export.dart';
import 'package:movieowski/src/ui/actor_card.dart';

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
  void dispose() {
    _bloc?.dispose();
    super.dispose();
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
                  children:
                      List<Widget>.generate(state.actors.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child:  HomeActorCard(
                              asStubCard: false,
                              posterPath: state.actors[index].profilePath,
                              actorName: state.actors[index].name)
                    );
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
