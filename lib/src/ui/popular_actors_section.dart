import 'package:flutter/material.dart';
import 'package:movieowski/src/blocs/base/bloc_event_state_builder.dart';
import 'package:movieowski/src/blocs/base/bloc_provider.dart';
import 'package:movieowski/src/blocs/home_page/bloc_popular_actors_section.dart';
import 'package:movieowski/src/blocs/home_page/bloc_popular_actors_section_event.dart';
import 'package:movieowski/src/blocs/home_page/bloc_popular_actors_section_state.dart';
import 'package:movieowski/src/ui/actor_card.dart';
import 'package:movieowski/src/utils/consts.dart';
import 'package:shimmer/shimmer.dart';

class PopularActorsSection extends StatefulWidget {
  @override
  _PopularActorsSectionState createState() => _PopularActorsSectionState();
}

class _PopularActorsSectionState extends State<PopularActorsSection> {
  PopularActorsSectionBloc _bloc;

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<PopularActorsSectionBloc>(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Padding(
        padding: EdgeInsets.only(top: 8.0, left: 16.0),
        child: Text('Actors', style: Theme.of(context).textTheme.headline),
      ),
      BlocEventStateBuilder<PopularActorsSectionEvent, PopularActorsSectionState>(
        bloc: _bloc,
        builder: (BuildContext context, PopularActorsSectionState state) {
          if (state is PopularActorsIsEmpty) {
            _bloc.emitEvent(FetchPopularActors());
            return SizedBox();
          } else if (state is PopularActorsError) {
            return Center(
              child: Text(
                state.errorMessage,
                style: Theme.of(context).textTheme.headline,
              ),
            );
          } else {
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
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: (state is PopularActorsIsLoaded)
                              ? HomeActorCard(state.actors[index].profilePath, state.actors[index].name)
                              : Shimmer.fromColors(
                                  baseColor: AppColors.lighterPrimary,
                                  highlightColor: Colors.grey,
                                  child: HomeActorCard('/rDvhukiXfx1AJYZMwxeBKwfJm73.jpg', ''),
                                ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      )
    ]);
  }
}
