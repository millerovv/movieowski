import 'dart:math';

import 'package:flutter/material.dart';
import 'package:movieowski/src/ui/widget/actor_card.dart';
import 'package:movieowski/src/ui/widget/movie_card.dart';
import 'package:movieowski/src/utils/consts.dart';
import 'package:movieowski/src/utils/ui_utils.dart';

class HomePageShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        _createMoviesSection(context, true, true),
        _createMoviesSection(context, false, true),
        _createActorsSection(context),
        _createMoviesSection(context, true, false),
        _createGenresSection(context)
      ]),
    );
  }

  Widget _createSectionHead(BuildContext context, bool withSeeAllOption) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0, left: 16.0, right: withSeeAllOption ? 16.0 : 0.0),
      child: shimmer(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Text('sectionhead',
              style: Theme.of(context).textTheme.headline.copyWith(
                    background: Paint()..color = Colors.black,
                  )),
          withSeeAllOption
              ? Text('see all',
                  style: Theme.of(context).textTheme.body1.copyWith(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold,
                      background: Paint()..color = Colors.black))
              : SizedBox(),
        ],
      )),
    );
  }

  Widget _createMoviesSection(BuildContext context, bool withSeeAllOption, bool withRating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _createSectionHead(context, withSeeAllOption),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          height: 224.3,
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: NeverScrollableScrollPhysics(),
            child: shimmer(Row(
              children: List<Widget>.generate(_calculateNumberOfMovieCardsForDisplayWidth(context), (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                  child: MovieCard(
                    withRating: withRating,
                    asStubCard: true,
                  ),
                );
              }),
            )),
          ),
        ),
      ],
    );
  }

  Widget _createActorsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _createSectionHead(context, false),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: NeverScrollableScrollPhysics(),
            child: shimmer(Row(
              children: List<Widget>.generate(_calculateNumberOfActorCardsForDisplayWidth(context), (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                  child: ActorCircleImage(asStubCard: true),
                );
              }),
            )),
          ),
        ),
      ],
    );
  }

  Widget _createGenresSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _createSectionHead(context, false),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: NeverScrollableScrollPhysics(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    width: 500.0,
                    child: shimmer(Wrap(
                      spacing: 8.0,
                      children: List<Widget>.generate(14, (index) {
                        return Chip(
                          backgroundColor: AppColors.accentColor,
                          padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 2.0),
                          label: Text(
                            kGenresEmojis.keys.toList()[Random().nextInt(19)],
                            style: Theme.of(context).textTheme.body1,
                          ),
                        );
                      }),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  int _calculateNumberOfMovieCardsForDisplayWidth(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double movieCardWidth = MovieCard.defaultImageWidth;
    return (displayWidth / movieCardWidth).round() + 1;
  }

  int _calculateNumberOfActorCardsForDisplayWidth(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double actorCardWidth = ActorCircleImage.defaultWidth;
    return (displayWidth / actorCardWidth).round() + 1;
  }
}
