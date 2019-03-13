import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieowski/src/blocs/home_page/actors/bloc_popular_actors_section.dart';
import 'package:movieowski/src/blocs/home_page/actors/bloc_popular_actors_section_event.dart';
import 'package:movieowski/src/blocs/home_page/actors/bloc_popular_actors_section_state.dart';
import 'package:movieowski/src/blocs/home_page/home_page_bloc.dart';
import 'package:movieowski/src/blocs/home_page/home_page_event.dart';
import 'package:movieowski/src/ui/actor_card.dart';

class PopularActorsSection extends StatefulWidget {
  @override
  _PopularActorsSectionState createState() => _PopularActorsSectionState();
}

class _PopularActorsSectionState extends State<PopularActorsSection> {
  PopularActorsSectionBloc _bloc;
  HomePageBloc _supervisorBloc;

  StreamSubscription<PopularActorsSectionState> _sectionBlocSubscription;

  @override
  void initState() {
    super.initState();
    _supervisorBloc = BlocProvider.of<HomePageBloc>(context);
    _bloc = BlocProvider.of<PopularActorsSectionBloc>(context);
    _subscribeToSectionBloc();
  }

  @override
  void dispose() {
    _unsubscribeFromSectionBloc();
    _bloc?.dispose();
    _supervisorBloc?.dispose();
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
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          List<Widget>.generate((state is PopularActorsIsLoaded) ? state.actors.length : 5, (index) {
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
                ),
              ],
            );
          } else {
            return SizedBox();
          }
        },
      )
    ]);
  }

  void _subscribeToSectionBloc() {
    if (_bloc.state != null) {
      _sectionBlocSubscription = _bloc.state.skip(1).listen((PopularActorsSectionState state) {
        if (state is PopularActorsIsLoaded) {
          _supervisorBloc.dispatch(PopularActorsLoaded());
        } else if (state is PopularActorsError) {
          _supervisorBloc.dispatch(PopularActorsLoadingFailed(state.errorMessage));
        }
      });
    }
  }

  void _unsubscribeFromSectionBloc() {
    if (_sectionBlocSubscription != null) {
      _sectionBlocSubscription.cancel();
      _sectionBlocSubscription = null;
    }
  }
}
